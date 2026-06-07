# A deployment script utilizing nixos-anywhere
#
# 1. Generates new SSH and Age Keys
# 2. Updates all secrets of that host
# 3. Deploys config with new Keys
@example "Deploy Zarqa" {deploy zarqa 192.168.2.201}
@example "Deploy Zarqa and generate facter.json" {deploy zarqa 192.168.2.201 --generate-hardware-report}
def main [host: string, ip: string, --generate-hardware-report]: nothing -> nothing {
    # Work on raw YAML text for anchors
    let raw = open --raw .sops.yaml

    let anchor = $"host_($host)"
    if not ($raw | str contains $"&($anchor)") {
        error make $"Host anchor ($anchor) not found in .sops.yaml"
    }

    let old_age_key = $raw | parse --regex $"&($anchor) \(?<key>age[0-9a-z]+\)" | get key.0
    if ($old_age_key | is-empty) {
        error make $"Failed to extract old age key for ($anchor)"
    }

    # Create temp dir
    let tempdir = mktemp -d
    let ssh_dir = ($tempdir)/etc/ssh
    mkdir $ssh_dir

    let rsa_key = $"($ssh_dir)/ssh_host_rsa_key"
    let ed25519_key = $"($ssh_dir)/ssh_host_ed25519_key"

    ssh-keygen -t rsa -b 4096 -f $rsa_key -N "" -C $host
    ssh-keygen -t ed25519 -f $ed25519_key -N "" -C $host

    let age_pub = open --raw $"($ed25519_key).pub" | ssh-to-age

    # Replace anchor in raw YAML
    $raw
    | str replace -r $"&($anchor) age[0-9a-z]+" $"&($anchor) ($age_pub)"
    | save --force .sops.yaml

    print $"Updated .sops.yaml for ($host)"

    let git_files = git ls-files | lines

    ".sops.yaml"
    | open
    | get creation_rules
    | where {|rule|
        $rule.key_groups | any {|kg|
            $kg.age | any {|k| $k == $age_pub }
        }
    }
    | get path_regex
    | par-each {|regex| $git_files | where {|f| $f =~ $regex } }
    | flatten
    | uniq
    | each {|file_to_reencrypt|
        print $"Re-encrypting ($file_to_reencrypt)"
        sops updatekeys $file_to_reencrypt
        print # needed so that updatekeys output is shown
    }

    nixos-anywhere --flake $".#($host)" (
        if $generate_hardware_report { $"--generate-hardware-config nixos-facter ./modules/hosts/($host)/facter.json" } else { "" }
    ) --target-host $"root@($ip)" --extra-files $tempdir

    # Remove lingering temp directory.
    # We only care about the successful case because
    # failing means the keys won't be used anyway
    rm -rf $tempdir
}
