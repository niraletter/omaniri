sudo tee /etc/sudoers.d/omaniri-power-profile >/dev/null <<EOF
$USER ALL=(root) NOPASSWD: /usr/bin/tee /sys/firmware/acpi/platform_profile
EOF

sudo chmod 440 /etc/sudoers.d/omaniri-power-profile

echo "Applied sudoers power profile toggle"