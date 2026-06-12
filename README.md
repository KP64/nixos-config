# Nix Config

<div align="center">

![GitHub Repo stars](https://img.shields.io/github/stars/KP64/nixos-config?style=for-the-badge&logo=starship&logoColor=%23cad3f5&labelColor=%23181825&color=%2311111B&link=https%3A%2F%2Fgithub.com%2FKP64%2Fnixos-config)
![GitHub repo size](https://img.shields.io/github/repo-size/KP64/nixos-config?style=for-the-badge&logo=github&logoColor=%23cad3f5&labelColor=%23181825&color=%2311111B&link=github.com%2FKP64%2Fnixos-config)
![Static Badge](https://img.shields.io/badge/nixos-unstable-blue?style=for-the-badge&logo=nixos&logoColor=%23cad3f5&labelColor=%23181825&color=%2311111B&link=https%3A%2F%2Fgithub.com%2FKP64%2Fnixos-config)
![Static Badge](https://img.shields.io/badge/unlicense-%2311111b?style=for-the-badge&logo=unlicense&logoColor=%23cdd6f4&labelColor=%23181825)

</div>

## 📝 About

A wannabe size fits it all NixOS Configuration using flakes.
It is encouraged to try, modify and break it all you like!
Don't believe me? Look at the ["License"](UNLICENSE) :D

## Hosts

|                   Name                   |                  Hardware                   |     Arch      |
| :--------------------------------------: | :-----------------------------------------: | :-----------: |
|     [aladdin](modules/hosts/aladdin)     |   AMD Ryzen 7 2700X Eight-Core Processor    | x86_64-linux  |
|       [mahdi](modules/hosts/mahdi)       | 2xIntel(R) Xeon(R) CPU E5-2698 v3 @ 2.30GHz | x86_64-linux  |
|    [morgiana](modules/hosts/morgiana)    |                 ARM Limited                 | aarch64-linux |
| [sheherazade](modules/hosts/sheherazade) |                 ARM Limited                 | aarch64-linux |
|       [zarqa](modules/hosts/zarqa)       |                 ARM Limited                 | aarch64-linux |

> [!Note]
> Some hosts like `sindbad` are not managed by Nix and therefore not added here.
> The users on these hosts are managed via standalone Home-Manager.

## Gallery

<details open>
  <summary>Catppuccin</summary>
  <img alt="Terminal" src="assets/gallery/catppuccin/terminal.png" />
  <img alt="Idle" src="assets/gallery/catppuccin/idle.png" />
  <img alt="Firefox" src="assets/gallery/catppuccin/firefox.png" />
</details>

## 🌐 Network Topology

![Main](assets/topology/main.svg)

![Net](assets/topology/network.svg)
