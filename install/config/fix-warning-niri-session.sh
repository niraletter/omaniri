# Silence the DEPRECATED warning from bare systemctl --user import-environment when niri-session runs
# Note this will be overwritten after niri updates to new version
sudo sed -i 's|^\s*systemctl --user import-environment$|& 2>/dev/null|' /usr/bin/niri-session