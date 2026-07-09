<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="default/plymouth/logo.png">
    <source media="(prefers-color-scheme: light)" srcset="default/plymouth/logo.png">
    <img src="default/plymouth/logo.png" alt="Omaniri" width="400">
  </picture>
</p>

<p align="center">
An opinionated Arch Linux desktop built around the <a href="https://github.com/YaLTeR/niri">niri</a> scrollable-tiling Wayland compositor.
</p>

Omaniri turns a fresh Arch Linux install into a complete Wayland desktop with niri, greetd, Waybar, Walker, themed application defaults, hardware-specific setup, and the `omaniri` command-line tools for managing the system after install.

## Install

The recommended path is the [Omaniri ISO](https://github.com/niraletter/omaniri-iso/releases). It boots into the Omaniri configurator, installs Arch, and then runs this installer.

If you already have a fresh Arch install, run:

```bash
curl -fsSL https://niraletter.github.io/omaniri | bash
```

See [Manual Installation](docs/manual-installation.md) if you cannot use the ISO.

## What It Sets Up

- `niri` as the main Wayland compositor
- greetd login, Plymouth boot theme, Limine bootloader integration, and Snapper support
- Waybar, Walker, mako, hyprlock, hypridle, terminals, browser, editor, media, screenshot, and system utilities
- Omaniri themes and generated app configs
- GPU, laptop, ASUS, Surface, audio, Bluetooth, Docker, firewall, and power-related setup where applicable
- Package installation from official Arch repos, selected Chaotic-AUR packages, and AUR packages through `yay`

## Requirements

- Arch Linux
- Internet access for manual installation
- A user with sudo access
- Secure Boot disabled unless you have configured your own signing flow

## Community

Come say hi, get help with install issues, or show off your setup.

[![Discord](https://img.shields.io/badge/Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/qR5UZaSUfT)

## License

Omaniri is released under the [MIT License](LICENSE).
