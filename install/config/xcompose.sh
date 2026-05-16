# Set default XCompose that is triggered with CapsLock
tee ~/.XCompose >/dev/null <<EOF
# Run omaniri-restart-xcompose to apply changes

# Include fast emoji access
include "%H/.local/share/omaniri/default/xcompose"

# Identification
<Multi_key> <space> <n> : "$OMANIRI_USER_NAME"
<Multi_key> <space> <e> : "$OMANIRI_USER_EMAIL"
EOF
