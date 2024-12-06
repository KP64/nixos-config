<div align="center"><img src="./assets/nix.svg" width="100px" /></div>

<h1 align="center">NixOS Config</h1>

<div align="center">

![GitHub Repo stars](https://img.shields.io/github/stars/KP64/nixos-config?style=for-the-badge&logo=starship&logoColor=%23cad3f5&labelColor=%23181825&color=%2311111B&link=https%3A%2F%2Fgithub.com%2FKP64%2Fnixos-config)
![GitHub repo size](https://img.shields.io/github/repo-size/KP64/nixos-config?style=for-the-badge&logo=github&logoColor=%23cad3f5&labelColor=%23181825&color=%2311111B&link=github.com%2FKP64%2Fnixos-config)
![Static Badge](https://img.shields.io/badge/nixos-unstable-blue?style=for-the-badge&logo=nixos&logoColor=%23cad3f5&labelColor=%23181825&color=%2311111B&link=https%3A%2F%2Fgithub.com%2FKP64%2Fnixos-config)
![Static Badge](https://img.shields.io/badge/unlicense-%2311111b?style=for-the-badge&logo=unlicense&logoColor=%23b4befe&labelColor=%23181825&link=https%3A%2F%2Funlicense.org%2F)

</div>

## 🗒 About

A wannabe size fits it all NixOS Configuration using flakes.
It is encouraged to try modify and break it all you like!
Don't believe me? Look at the ["License"](./UNLICENSE) :D

## ✨ Features

- ❄️ [Flakes](https://nixos.wiki/wiki/flakes)
- 🏡 [Home-Manager](https://github.com/nix-community/home-manager)
- 🪟 [WSL](https://github.com/nix-community/NixOS-WSL)
- 🫐 [Raspberry Pi](https://github.com/nix-community/raspberry-pi-nix)
- 💽 [Disko](https://github.com/nix-community/disko)
- ⚠️ [Impermanence](https://github.com/nix-community/impermanence)
- 🔐 [Sops-nix](https://github.com/Mic92/sops-nix)
- ♻️ [Nixos-anywhere](https://github.com/nix-community/nixos-anywhere)
- 🔐 [Lanzaboote](https://github.com/nix-community/lanzaboote)
- 🌐 [Topology](https://github.com/oddlama/nix-topology)
- 🐱 [Catppuccin](https://github.com/catppuccin/nix)
- 🖥️ [Minecraft Servers](https://github.com/Infinidoge/nix-minecraft)

<!-- TODO: - 💈[Stylix](https://github.com/danth/stylix) -->

## 📚 Layout

- [flake.nix](./flake.nix) ❄ base of the configuration
- [hosts](./hosts) 👻 per-host machine specific configurations
- [desktop](./desktop) 🖥️ Desktop modules
- [hardware](./hardware) ⚙️ Hardware modules
- [programs](./programs) 1️⃣ mandatory programs and optional to enable modules
- [services](./services) 0️⃣ nice to have services extracted into own modules with sensible defaults for easier setup
- [wallpapers](./desktop/wallpapers) 🌄 Wallpaper Collection

## ⚙ Components

<!-- TODO: Add qview 1 -->

<!-- TODO: | Color Scheme            | [Catppuccin](https://github.com/catppuccin/nix) + [Stylix](https://github.com/danth/stylix)                                           | -->

<!-- TODO: | Image Viewer            | ()                                                                                                                                    | -->

| Component               | Choice(s)                                                                                                                                        |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| Window Manager          | [Hyprland](https://github.com/hyprwm/Hyprland)                                                                                                   |
| Bar                     | [Hyprpanel](https://github.com/Jas-SinghFSU/HyprPanel)                                                                                           |
| App Launcher            | [Rofi-wayland](https://github.com/lbonn/rofi)                                                                                                    |
| Notification Daemon     | [Hyprpanel](https://github.com/Jas-SinghFSU/HyprPanel)                                                                                           |
| Terminal Emulatro       | [Kitty](https://github.com/kovidgoyal/kitty)                                                                                                     |
| Shell                   | [Bash](https://www.gnu.org/software/bash/) + [Nushell](https://github.com/nushell/nushell) + [Starship](https://github.com/starship/starship)    |
| Text Editor             | [Vscodium](https://github.com/VSCodium/vscodium) + [Helix](https://github.com/helix-editor/helix) + [Zed](https://github.com/zed-industries/zed) |
| Networking              | [NetworkManager](https://networkmanager.dev/) + [network-manager-applet](https://gitlab.gnome.org/GNOME/network-manager-applet)                  |
| System resource monitor | [Btop](https://github.com/aristocratos/btop)                                                                                                     |
| File Manager            | [Broot](https://github.com/Canop/broot) + [Yazi](https://github.com/sxyazi/yazi)                                                                 |
| Fonts                   | [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts) + [JetBrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts)               |
| Color Scheme            | [Catppuccin](https://github.com/catppuccin/nix)                                                                                                  |
| Cursor                  | [Catppuccin Cursors](https://github.com/catppuccin/nix)                                                                                          |
| Icons                   | [Catppuccin Icons](https://github.com/catppuccin/nix)                                                                                            |
| Lockscreen              | [Hyprlock](https://github.com/hyprwm/hyprlock)                                                                                                   |
| Media Player            | [mpv](https://github.com/mpv-player/mpv)                                                                                                         |
| Music Player            | [Spicetify](https://spicetify.app/)                                                                                                              |
| Screenshotting          | [grimblast](https://github.com/hyprwm/contrib/tree/main/grimblast)                                                                               |
| Screen Recording        | [OBS](https://github.com/obsproject/obs-studio)                                                                                                  |
| Clipboard               | [wl-clipboard-rs](https://github.com/YaLTeR/wl-clipboard-rs) + [Copyq](https://github.com/hluk/CopyQ)                                            |
| Color Picker            | [Hyprpicker](https://github.com/hyprwm/hyprpicker)                                                                                               |
| Touch Screen Gestures   | [Hyprgrass](https://github.com/horriblename/hyprgrass)                                                                                           |

## 🖼️ Gallery

<!-- TODO: Images -->

## 🐚 Shell aliases

For Bash:

```sh
alias cd = z
alias ls = lsd
alias ll = lsd -l
alias la = lsd -A
alias lt = lsd --tree
alias lla = lsd -lA
alias llt = lsd -l --tree
```

For Nushell:

```sh
alias cd = z
alias ll = ls -l
alias la = ls -a
alias lla = ls -la
```

and more at [nushell.nix](./programs/cli/shells/nushell/default.nix)

## ⌨ Keybinds

Look at the [Hyprland.nix](./desktop/hypr/hyprland.nix) file

## ️🖥️ Hosts

| Hostname | Board             | CPU                 | RAM        | GPU                   | OS    |
| -------- | ----------------- | ------------------- | ---------- | --------------------- | ----- |
| kg       | B450 Steel Legend | Ryzen 7 2700X       | 16GB DDR4  | RTX 2070 Super        | NixOS |
| tp       | Lenovo Yoga 370   | Intel Core i7-7600U | 8GB DDR4   | Intel HD Graphics 620 | NixOS |
| ws       | WSL               | WSL                 | WSL        | WSL                   | NixOS |
| rs       | Raspberry Pi 400  | ARM-Cortex-A72-CPU  | 4GB LPDDR4 | Broadcom bcm2711-vc5  | NixOS |

## 👀 Network Topology

![Main](./assets/topology/main.svg)

![Net](./assets/topology/network.svg)
