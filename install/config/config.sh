# Copy over omaniri configs
mkdir -p ~/.config
cp -R ~/.local/share/omaniri/config/* ~/.config/

# Use default bashrc from omaniri
cp ~/.local/share/omaniri/default/bashrc ~/.bashrc
