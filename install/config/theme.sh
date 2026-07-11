# Set links for Nautilus action icons
sudo ln -snf /usr/share/icons/Adwaita/symbolic/actions/go-previous-symbolic.svg /usr/share/icons/Yaru/scalable/actions/go-previous-symbolic.svg
sudo ln -snf /usr/share/icons/Adwaita/symbolic/actions/go-next-symbolic.svg /usr/share/icons/Yaru/scalable/actions/go-next-symbolic.svg

# Setup user theme folder
mkdir -p ~/.config/omaniri/themes

# Google chrome policy directory for theme.
# Owned by the user (so omaniri-theme-set-browser can write the policy file)
# but never world-writable, otherwise any local user could drop enterprise
# policies (force extensions, disable safe-browsing).
sudo mkdir -p /etc/opt/chrome/policies/managed
sudo chown "${USER:-root}" /etc/opt/chrome/policies/managed
sudo chmod 0755 /etc/opt/chrome/policies/managed

# Set initial theme
omaniri-theme-set "Catppuccin"
rm -rf ~/.config/google-chrome/SingletonLock # otherwise archiso will own the Google chrome singleton

# Set specific app links for current theme
mkdir -p ~/.config/btop/themes
ln -snf ~/.config/omaniri/current/theme/btop.theme ~/.config/btop/themes/current.theme

mkdir -p ~/.config/mako
ln -snf ~/.config/omaniri/current/theme/mako.ini ~/.config/mako/config

# Default Google chrome to follow system appearance ("device") instead of dark
echo '{"browser":{"theme":{"color_scheme":0,"color_scheme2":0}}}' | sudo tee /opt/google/chrome/initial_preferences >/dev/null
