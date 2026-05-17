# Temporary passwordless sudo for install.sh (removed in post-install/finished.sh).
# Requires one sudo password prompt here; the rest of the install runs without prompts.

if [[ -f /etc/sudoers.d/99-omaniri-installer ]]; then
  return 0
fi

echo "Enable passwordless sudo for this install (you will be prompted once)..."
sudo tee /etc/sudoers.d/99-omaniri-installer >/dev/null <<EOF
# omaniri install — removed when install completes
$USER ALL=(ALL) NOPASSWD: ALL
EOF
sudo chmod 440 /etc/sudoers.d/99-omaniri-installer
