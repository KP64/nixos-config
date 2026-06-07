# Fetches the mods' URLs and their hash from modrinth via their IDs
#
# To get the ID of a mod visit the exact version of the mod
# you want to install and scroll down. You will find it under the
# `Version ID` section immediately under the publisher
@example $"Fetch (ansi yellow)Fabric API 0.116.9+1.21.1(ansi reset)" {prefetch yGAe1owa}
def main [...mod_ids: string]: nothing -> nothing {
    $mod_ids | par-each { nix-modrinth-prefetch $in } | print --raw
}
