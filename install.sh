#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

# Define omaniri locations
export OMANIRI_PATH="$HOME/.local/share/omaniri"
export OMANIRI_INSTALL="$OMANIRI_PATH/install"
export OMANIRI_INSTALL_LOG_FILE="/var/log/omaniri-install.log"
export PATH="$OMANIRI_PATH/bin:$PATH"

# Keep sudo alive for the whole install so run_logged
# steps don't fail asking for a password.
source "$OMANIRI_PATH/bin/omaniri-sudo-keepalive"

# Install
source "$OMANIRI_INSTALL/helpers/all.sh"
source "$OMANIRI_INSTALL/preflight/all.sh"
source "$OMANIRI_INSTALL/packaging/all.sh"
source "$OMANIRI_INSTALL/config/all.sh"
source "$OMANIRI_INSTALL/login/all.sh"
source "$OMANIRI_INSTALL/post-install/all.sh"
