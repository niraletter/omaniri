# Set env for nvidia

if lspci | grep -qi 'nvidia'; then
  mkdir -p "$HOME/.config/environment.d"
  ENV_FILE="$HOME/.config/environment.d/10-nvidia.conf"

  if omaniri-hw-nvidia-gsp; then
    cat > "$ENV_FILE" <<'EOF'
# NVIDIA (Turing+ with GSP firmware)
NVD_BACKEND=direct
LIBVA_DRIVER_NAME=nvidia
__GLX_VENDOR_LIBRARY_NAME=nvidia
EOF

  elif omaniri-hw-nvidia-without-gsp; then
    cat > "$ENV_FILE" <<'EOF'
# NVIDIA (Maxwell/Pascal/Volta without GSP firmware)
NVD_BACKEND=egl
__GLX_VENDOR_LIBRARY_NAME=nvidia
EOF
  fi
fi
