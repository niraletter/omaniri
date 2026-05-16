# Install all base packages
mapfile -t packages < <(grep -v '^#' "$OMANIRI_INSTALL/omaniri-base.packages" | grep -v '^$')
omaniri-pkg-add "${packages[@]}"
