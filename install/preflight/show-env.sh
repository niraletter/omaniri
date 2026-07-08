# Show installation environment variables
gum log --level info "Installation Environment:"

env | grep -E "^(OMANIRI_CHROOT_INSTALL|OMANIRI_ONLINE_INSTALL|OMANIRI_USER_NAME|OMANIRI_USER_EMAIL|USER|HOME|OMANIRI_REPO|OMANIRI_REF|OMANIRI_PATH)=" | sort | while IFS= read -r var; do
  gum log --level info "  $var"
done
