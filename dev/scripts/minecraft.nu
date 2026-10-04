def main [] { }

# Connects to the console of a running minecraft server via tmux
@example $"Connect to server named (ansi yellow)Survival(ansi reset)" {attach Survival}
def "main attach" [server_to_connect_to: string]: nothing -> nothing {
    sudo tmux -S /run/minecraft/($server_to_connect_to).sock attach
}

# Fetches the mods' URLs and their hash from modrinth via their IDs
#
# To get the ID of a mod visit the exact version of the mod
# you want to install and scroll down. You will find it under the
# `Version ID` section immediately under the publisher
@example $"Fetch (ansi yellow)Fabric API 0.116.9+1.21.1(ansi reset)" {prefetch yGAe1owa}
def "main prefetch" [...mod_ids: string]: nothing -> nothing {
    $mod_ids | par-each { nix-modrinth-prefetch $in } | print --raw
}

# Resets the progress of a minecraft server.
@example $"Reset the (ansi yellow)Hardcore(ansi reset) Server" {reset Hardcore}
def "main reset" [server_to_reset: string]: nothing -> nothing {
    let systemd_name = $"minecraft-server-($server_to_reset)"
    sudo systemctl stop $systemd_name | complete
    sudo rm -rf /srv/minecraft/($server_to_reset)/world
    sudo systemctl start $systemd_name | complete
    return
}
