# Omaniri

Omaniri is an opinionated setup for CachyOS with niri, configured around my personal workflow and preferences.

> [!WARNING]
> Do **not** run this blindly on a running setup unless you fully understand what the installer modifies.

## Prerequisites

Before running the CachyOS installer, trim the default package selection to avoid conflicts with what Omaniri manages itself.

### Network packages

In the **Network** group, untick everything except:

- `iwd`
- `wireless-regdb`
- `usb_modeswitch` - only if you use a USB 3G/4G dongle

Omaniri uses `iwd` + `systemd-networkd` directly, no NetworkManager.

### Other packages to untick

In **CachyOS shell configuration**: `cachyos-fish-config`, `cachyos-zsh-config`

In **Power**: `cpupower`

In **Packages management**: `paru`

Omaniri handles these itself with its own configuration.

## Setup
Omaniri expects **iwd** for networking, not NetworkManager. Set that up in the CachyOS installer, connect once in the TTY, then run `install.sh`.

### 1. Connect to the network

Log in at the console as your user (not root).

**Start `iwd` if it's not running:**

```bash
sudo systemctl enable --now iwd
```
**Wi‑Fi** - interactive:

```bash
iwctl
```

Inside `iwctl`:

```text
device list
station <device> scan
station <device> get-networks
station <device> connect <ssid>
exit
```

Replace `<device>` with your wireless interface (often `wlan0`). You will be prompted for the Wi‑Fi password.

**Wi‑Fi** - one-liner (after you know the SSID):

```bash
iwctl station wlan0 connect "YourSSID"
```


**Ethernet** - usually works once the cable is plugged in; confirm with:

```bash
ping -c 3 1.1.1.1
```

### 2. Set up DHCP with systemd-networkd

iwd handles the Wi‑Fi association but not IP assignment. You need `systemd-networkd` to get an IP address via DHCP.

Create a network profile (replace `wlan0` if your interface name differs — check with `ip link`):

```bash
sudo nano /etc/systemd/network/25-wireless.network
```

```ini
[Match]
Name=wlan0

[Network]
DHCP=yes
```

Start the services and fix DNS:

```bash
sudo systemctl start systemd-networkd
sudo systemctl start systemd-resolved
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
sudo systemctl restart systemd-networkd
```

Enable them so they start automatically on every boot:

```bash
sudo systemctl enable systemd-networkd systemd-resolved iwd
```

Confirm you have internet:

```bash
ping -c 3 1.1.1.1
```

### 3. Install

```bash
sudo pacman -Syu --needed git
git clone https://github.com/niraletter/omaniri.git ~/.local/share/omaniri
cd ~/.local/share/omaniri
bash install.sh
```

### 4. Post-Install
```bash
# setup elephant providers
yay -S elephant-bin elephant-symbols-bin elephant-clipboard-bin elephant-files-bin elephant-desktopapplications-bin elephant-providerlist-bin elephant-menus-bin
elephant service enable
systemctl --user start elephant.service

# configure firewall and ports
bash ~/.local/share/omaniri/install/first-run/firewall.sh
```

## License

Omaniri is released under the [MIT License](LICENSE).
