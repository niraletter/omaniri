stop_install_log

echo_in_style() {
  if command -v tte >/dev/null 2>&1; then
    echo "$1" | tte --canvas-width 0 --anchor-text c --frame-rate 640 print
  else
    echo "$1"
  fi
}

show_logo() {
  if command -v tte >/dev/null 2>&1; then
    tte -i ~/.local/share/omaniri/logo.txt --canvas-width 0 --anchor-text c --frame-rate 920 laseretch
  else
    cat ~/.local/share/omaniri/logo.txt
  fi
}

clear
echo
show_logo
echo

# Display installation time if available
if [[ -f $OMANIRI_INSTALL_LOG_FILE ]] && grep -q "Total:" "$OMANIRI_INSTALL_LOG_FILE" 2>/dev/null; then
  echo
  TOTAL_TIME=$(tail -n 20 "$OMANIRI_INSTALL_LOG_FILE" | grep "^Total:" | sed 's/^Total:[[:space:]]*//')
  if [[ -n $TOTAL_TIME ]]; then
    echo_in_style "Installed in $TOTAL_TIME"
  fi
else
  echo_in_style "Finished installing"
fi

if sudo -n test -f /etc/sudoers.d/99-omaniri-installer 2>/dev/null; then
  sudo -n rm -f /etc/sudoers.d/99-omaniri-installer &>/dev/null || true
fi

# Exit gracefully if user chooses not to reboot
if gum confirm --padding "0 0 0 $((PADDING_LEFT + 32))" --show-help=false --default --affirmative "Reboot Now" --negative "" ""; then
  # Clear screen to hide any shutdown messages
  clear

  if [[ -n ${OMANIRI_CHROOT_INSTALL:-} ]]; then
    touch /var/tmp/omaniri-install-completed
    exit 0
  else
    sudo -n reboot 2>/dev/null || reboot 2>/dev/null || true
  fi
fi
