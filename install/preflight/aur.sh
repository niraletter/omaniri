if ! command -v yay &>/dev/null; then
  if [[ -n ${OMANIRI_CHROOT_INSTALL:-} && -z ${OMANIRI_ONLINE_INSTALL:-} ]]; then
    # Offline ISO install: yay-bin is pre-built into the [offline] mirror, so
    # install it from there instead of cloning and building from the AUR online.
    sudo pacman -S --noconfirm --needed yay-bin
  else
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
    cd "$tmpdir/yay-bin"
    makepkg -si --noconfirm
    rm -rf "$tmpdir"
  fi
fi
