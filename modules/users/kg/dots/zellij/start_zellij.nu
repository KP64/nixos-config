# Starts Zellij depending on its configuration
def start-zellij []: nothing -> nothing {
    if "ZELLIJ" in $env {
        return
    }
    if ($env.ZELLIJ_AUTO_ATTACH? | default "false") == "true" {
        zellij attach -c
    } else {
        zellij
    }
    if ($env.ZELLIJ_AUTO_EXIT? | default "false") == "true" {
        exit
    }
}
start-zellij
