# Install yaru-icon-theme and asusctl from Chaotic-AUR.
# Only these two packages should come from Chaotic-AUR.
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' --noconfirm
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm

echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
sudo pacman -Sy

sudo pacman -S --noconfirm yaru-icon-theme asusctl

# Remove Chaotic-AUR from pacman.conf — only needed for the two packages above
sudo sed -i '/^\[chaotic-aur\]/,/^Include/d' /etc/pacman.conf
