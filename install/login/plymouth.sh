if [[ $(plymouth-set-default-theme) != "omaniri" ]]; then
  sudo cp -r "$HOME/.local/share/omaniri/default/plymouth" /usr/share/plymouth/themes/omaniri/
  sudo plymouth-set-default-theme omaniri
fi
