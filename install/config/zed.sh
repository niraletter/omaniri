# Set Zed theme to Omazed on first install
omaniri-cmd-missing zeditor && exit 0

ZED_SETTINGS="$HOME/.config/zed/settings.json"
mkdir -p "$(dirname "$ZED_SETTINGS")"

[[ ! -f $ZED_SETTINGS ]] && echo '{}' > "$ZED_SETTINGS"

if ! grep -q '"theme"' "$ZED_SETTINGS"; then
  tmp=$(mktemp)
  sed 's/^{/{  "theme": "Omazed",/' "$ZED_SETTINGS" > "$tmp"
  mv "$tmp" "$ZED_SETTINGS"
fi

omaniri-theme-set-zed