if [[ -n ${OMANIRI_ONLINE_INSTALL:-} ]]; then
  # Install build tools
  omaniri-pkg-add base-devel
  
  # Configure pacman
  sudo cp -f ~/.local/share/omaniri/default/pacman/pacman.conf /etc/pacman.conf
  
  sudo pacman -Sy
  omaniri-pkg-add archlinux-keyring

  # Refresh all repos
  sudo pacman -Syyuu --noconfirm
fi  
