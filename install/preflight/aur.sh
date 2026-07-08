if ! command -v yay &>/dev/null; then
  cd /tmp
  rm -rf yay-bin
  git clone https://aur.archlinux.org/yay-bin.git
  cd yay-bin
  makepkg -si --noconfirm
  cd -
  rm -rf yay-bin
  cd ~
fi