# Copy over omaniri configs
mkdir -p ~/.config
cp -R ~/.local/share/omaniri/config/* ~/.config/

# Use default bashrc and bash_profile from omaniri
cp ~/.local/share/omaniri/default/bashrc ~/.bashrc
cp ~/.local/share/omaniri/default/bash_profile ~/.bash_profile
