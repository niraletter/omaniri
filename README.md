# Omaniri

Omaniri is an opinionated setup for CachyOS with niri, configured around my personal workflow and preferences.

## Setup

Omaniri expects **iwd** for networking, not NetworkManager. Set that up in the CachyOS installer, connect once in the TTY, then run `install.sh`.

### 1. Connect to the network

Log in at the console as your user (not root).

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

Start it if needed:

```bash
sudo systemctl enable --now iwd
```

### 2. Install 

```bash
sudo pacman -Syu --needed git
git clone https://github.com/niraletter/omaniri.git ~/.local/share/omaniri
cd ~/.local/share/omaniri
bash install.sh
```

## License

Omaniri is released under the [MIT License](LICENSE).