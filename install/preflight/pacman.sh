if [[ -n ${OMANIRI_ONLINE_INSTALL:-} ]]; then
  # Install build tools
  omaniri-pkg-add base-devel

  # Add Chaotic-AUR for pre-built AUR package binaries
  sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
  sudo pacman-key --lsign-key 3056513887B78AEB
  sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' --noconfirm
  sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm

  # Configure pacman
  sudo cp -f ~/.local/share/omaniri/default/pacman/pacman.conf /etc/pacman.conf

  sudo pacman -Sy
  omaniri-pkg-add archlinux-keyring

  # Refresh all repos
  sudo pacman -Syyuu --noconfirm
else
  # Offline ISO install: sync the [offline] mirror database so pacman -Si/-S
  # can resolve the pre-built packages inside the chroot.
  sudo pacman -Sy
fi
