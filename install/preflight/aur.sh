  if ! command -v yay &>/dev/null; then
  if pacman -Si yay-bin &>/dev/null; then
    sudo pacman -S --noconfirm yay-bin
  elif [[ -n ${OMANIRI_ONLINE_INSTALL:-} ]]; then
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
    cd "$tmpdir/yay-bin"
    makepkg -si --noconfirm
    rm -rf "$tmpdir"
  else
    echo "yay-bin package not found in the prebuilt offline mirror." >&2
    exit 1
  fi
fi
