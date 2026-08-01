# Setup user theme folder and seed the default only when no theme exists yet.
mkdir -p ~/.config/omaniri/themes

if [[ ! -s $HOME/.local/state/omaniri/current/theme.name ]]; then
  # iso-chroot and provision-owner both run without a live session to notify.
  if [[ ${OMANIRI_SETUP_CONTEXT:-runtime} != "runtime" ]]; then
    OMANIRI_THEME_HEADLESS=1 omaniri-theme-set "Catppuccin"
    rm -f ~/.config/chromium/SingletonLock # otherwise archiso owns the Chromium singleton
  else
    omaniri-theme-set "Catppuccin"
  fi
fi
omaniri-theme-set-pi --activate

mkdir -p ~/.config/btop/themes
ln -snf "$HOME/.local/state/omaniri/current/theme/btop.theme" ~/.config/btop/themes/current.theme
