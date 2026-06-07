# Connects to the console of a running minecraft server via tmux
@example $"Connect to server named (ansi yellow)Survival(ansi reset)" {attach Survival}
def main [server_to_connect_to: string]: nothing -> nothing {
    sudo tmux -S /run/minecraft/($server_to_connect_to).sock attach
}
