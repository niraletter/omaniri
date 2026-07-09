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

## Install

The recommended path is the [Omaniri ISO](https://github.com/niraletter/omaniri-iso/releases). It boots into the Omaniri configurator, installs Arch, and then runs this installer.

To install Omaniri on a fresh Arch Linux installation, run:

```bash
curl -fsSL https://niraletter.github.io/omaniri | bash
```

If you cannot use the Omaniri ISO, follow the [Manual Installation Guide](docs/manual-installation.md) to install with the standard Arch Linux ISO and `archinstall`.

> [!WARNING]
> Only use the manual installation method if you know what you're doing.

## What Omaniri Includes

Omaniri configures a ready-to-use Arch desktop centered on `niri`, with the login, boot, snapshot, theming, and core app stack handled for you.

- `niri` as the main Wayland compositor
- greetd login, Plymouth boot theme, Limine bootloader integration, and Snapper support
- Waybar, Walker, mako, hyprlock, hypridle, terminals, browser, editor, media, screenshot, and system utilities
- Omaniri themes and generated app configs
- Hardware-aware setup for supported GPUs, laptops, ASUS systems, Surface devices, audio, Bluetooth, Docker, firewall, and power management

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
