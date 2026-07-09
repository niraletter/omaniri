# Manual installation

If you can't use the Omaniri ISO, you can do a manual installation using the vanilla Arch ISO, archinstall, and following the steps in this guide. This is not something most people should attempt, but if you know what you're doing, and why you're doing it, this is how.

1. [Download the Arch Linux ISO](https://archlinux.org/download/#http-downloads), put it on a USB stick (use [balenaEtcher](https://etcher.balena.io/) or [rufus](https://rufus.ie/) on Mac/Windows), and boot off the stick (remember to turn off Secure Boot in the BIOS!).

2. If you're on wifi, start by running `iwctl`, then type `station wlan0 scan`, then `station wlan0 connect <tab>`, pick your network, and enter the password. If you're on ethernet, you don't need this.

3. Run `archinstall` and pick these options (leave anything not mentioned as-is):

| Section | Option |
|---|---|
| Mirrors and repositories | (Optional) Select regions > Your country |
| Disk configuration | Partitioning > Default partitioning layout > Select disk (with space + return) |
| Disk > File system | btrfs (default structure: yes + use compression) |
| Disk > Disk encryption | (Optional) Encryption type: LUKS + Encryption password + Partitions (select the one) |
| Hostname | Give your computer a name |
| Bootloader | Limine |
| Authentication > Root password | Set yours |
| Authentication > User account | Add a user > Superuser: Yes > Confirm and exit |
| Applications > Audio | pipewire |
| Network configuration | Copy ISO network config |
| Timezone | Set yours |

Once Arch has been installed, pick reboot, login with the user you just setup, and now you're ready to install Omaniri by running:

```bash
curl -fsSL https://niraletter.github.io/omaniri | bash
```

It'll first ask you to sudo, then shortly thereafter, it'll ask for your name and email address. Those credentials are used to preconfigure git (`git config --global user.name/email`) and set for auto-expansion. After that, it'll run by itself for 5-30 minutes, depending on the speed of your internet connection. When it's all done, it'll ask for your permission to reboot the system.

The installer prompts for your sudo password at the beginning and keeps that sudo session alive while the install is running, so you should not need to re-enter your password during package installation.

## Package sources

Manual installation needs a working internet connection. Omaniri installs packages in this order:

1. Official Arch repo packages are installed with `pacman`.
2. Packages listed in `install/omaniri-chaotic.packages` are installed from Chaotic-AUR with a temporary pacman config.
3. Remaining packages are installed from the AUR with `yay`.

Packages used by the ISO builder follow the same split so the ISO can prebuild and cache them for offline installation.

Now you're ready to Omaniri!
