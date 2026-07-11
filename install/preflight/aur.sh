  if ! command -v yay &>/dev/null; then
  if pacman -Si yay-bin &>/dev/null; then
    sudo pacman -S --noconfirm yay-bin
  else
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
    cd "$tmpdir/yay-bin"
    makepkg -si --noconfirm
    rm -rf "$tmpdir"
  fi
fi
