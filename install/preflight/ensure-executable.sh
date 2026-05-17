# git clone does not mark bin/ scripts executable (mode 100644 in the index)
chmod -R u+x "$OMANIRI_PATH/bin"

if [[ -f $OMANIRI_PATH/install.sh ]]; then
  chmod u+x "$OMANIRI_PATH/install.sh"
fi
