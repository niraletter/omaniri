# Configure pacman after package installation completes. Offline target package
# installs use the live ISO's offline pacman.conf until this final restore.
cp -f "$OMANIRI_PATH/default/pacman/pacman-${OMANIRI_MIRROR:-stable}.conf" /etc/pacman.conf
cp -f "$OMANIRI_PATH/default/pacman/mirrorlist-${OMANIRI_MIRROR:-stable}" /etc/pacman.d/mirrorlist

# omaniri-settings skips this override until cups-browsed is actually present
# to avoid pacman creating cups-browsed.conf.pacnew during ISO package install.
if [[ -f $OMANIRI_PATH/etc-overrides/cups-cups-browsed.conf && -d /etc/cups ]]; then
  cp -f "$OMANIRI_PATH/etc-overrides/cups-cups-browsed.conf" /etc/cups/cups-browsed.conf
  rm -f /etc/cups/cups-browsed.conf.pacnew
fi

source "$OMANIRI_INSTALL/hardware/pacman.sh"
