stop_install_log

echo_in_style() {
  echo "$1" | tte --canvas-width 0 --anchor-text c --frame-rate 640 print
}

clear
echo
tte -i ~/.local/share/omaniri/logo.txt --canvas-width 0 --anchor-text c --frame-rate 920 laseretch
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

if sudo test -f /etc/sudoers.d/99-omaniri-installer; then
  sudo rm -f /etc/sudoers.d/99-omaniri-installer &>/dev/null
fi

# Exit gracefully if user chooses not to reboot
reboot_prompt="${PADDING_LEFT_SPACES}Reboot now? [Y/n] "
if [[ -e /dev/tty ]]; then
  printf '%s' "$reboot_prompt" >/dev/tty
  read -r reboot_answer </dev/tty
else
  printf '%s' "$reboot_prompt"
  read -r reboot_answer
fi

if [[ -z $reboot_answer || $reboot_answer =~ ^[Yy] ]]; then
  # Clear screen to hide any shutdown messages
  clear

  if [[ -n ${OMANIRI_CHROOT_INSTALL:-} ]]; then
    touch /var/tmp/omaniri-install-completed
    exit 0
  else
    sudo reboot 2>/dev/null
  fi
fi
