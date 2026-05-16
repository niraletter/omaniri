echo "Install greetd display manager configuration"

sudo mkdir -p /etc/greetd

if [[ -f /etc/greetd/config.toml ]]; then
  sudo cp /etc/greetd/config.toml "/etc/greetd/config.toml.bak.$(date +%s)"
fi

sed "s/@OMANIRI_USER@/$USER/" "$OMANIRI_PATH/default/greetd/config.toml" | sudo tee /etc/greetd/config.toml >/dev/null

if systemctl list-unit-files sddm.service &>/dev/null; then
  if systemctl is-enabled sddm.service &>/dev/null; then
    sudo systemctl disable --now sddm.service
  fi
fi

sudo systemctl enable greetd.service
