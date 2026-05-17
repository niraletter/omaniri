#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

OMANIRI_INSTALL_LOGO=$(cat <<'EOF'
 ▄██████▄     ▄▄▄▄███▄▄▄▄      ▄████████  ███▄▄▄▄     ▄█     ▄████████   ▄█
███    ███  ▄██▀▀▀███▀▀▀██▄   ███    ███  ███▀▀▀██▄  ███    ███    ███  ███
███    ███  ███   ███   ███   ███    ███  ███   ███  ███▌   ███    ███  ███▌
███    ███  ███   ███   ███   ███    ███  ███   ███  ███▌  ▄███▄▄▄▄██▀  ███▌
███    ███  ███   ███   ███ ▀███████████  ███   ███  ███▌ ▀▀███▀▀▀▀▀    ███▌
███    ███  ███   ███   ███   ███    ███  ███   ███  ███  ▀███████████  ███
███    ███  ███   ███   ███   ███    ███  ███   ███  ███    ███    ███  ███
 ▀██████▀    ▀█   ███   █▀    ███    █▀    ▀█   █▀   █▀     ███    ███  █▀
                                                            ███    ███
EOF
)
export OMANIRI_INSTALL_LOGO

show_install_banner() {
  printf '\033[H\033[2J'
  printf '\n%s\n\nInstalling...\n\n' "$OMANIRI_INSTALL_LOGO"
}

show_install_banner

# Define omaniri locations
export OMANIRI_PATH="$HOME/.local/share/omaniri"
export OMANIRI_INSTALL="$OMANIRI_PATH/install"
export OMANIRI_INSTALL_LOG_FILE="/var/log/omaniri-install.log"
export PATH="$OMANIRI_PATH/bin:$PATH"

source "$OMANIRI_INSTALL/preflight/ensure-executable.sh"
source "$OMANIRI_INSTALL/preflight/installer-sudoers.sh"

# Install
source "$OMANIRI_INSTALL/helpers/all.sh"
source "$OMANIRI_INSTALL/preflight/all.sh"
source "$OMANIRI_INSTALL/packaging/all.sh"
source "$OMANIRI_INSTALL/config/all.sh"
source "$OMANIRI_INSTALL/login/all.sh"
source "$OMANIRI_INSTALL/post-install/all.sh"
