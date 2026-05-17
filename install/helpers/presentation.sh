# Get terminal size from /dev/tty (works in all scenarios: direct, sourced, or piped)
if [[ -e /dev/tty ]]; then
  TERM_SIZE=$(stty size 2>/dev/null </dev/tty)

  if [[ -n $TERM_SIZE ]]; then
    export TERM_HEIGHT=$(echo "$TERM_SIZE" | cut -d' ' -f1)
    export TERM_WIDTH=$(echo "$TERM_SIZE" | cut -d' ' -f2)
  else
    # Fallback to reasonable defaults if stty fails
    export TERM_WIDTH=80
    export TERM_HEIGHT=24
  fi
else
  # No terminal available (e.g., non-interactive environment)
  export TERM_WIDTH=80
  export TERM_HEIGHT=24
fi

export LOGO_PATH="$OMANIRI_PATH/logo.txt"
if [[ -n ${OMANIRI_INSTALL_LOGO:-} ]]; then
  export LOGO_WIDTH=$(printf '%s\n' "$OMANIRI_INSTALL_LOGO" | awk '{ if (length > max) max = length } END { print max+0 }')
  export LOGO_HEIGHT=$(printf '%s\n' "$OMANIRI_INSTALL_LOGO" | wc -l)
else
  export LOGO_WIDTH=$(awk '{ if (length > max) max = length } END { print max+0 }' "$LOGO_PATH" 2>/dev/null || echo 0)
  export LOGO_HEIGHT=$(wc -l <"$LOGO_PATH" 2>/dev/null || echo 0)
fi

export PADDING_LEFT=$(((TERM_WIDTH - LOGO_WIDTH) / 2))
export PADDING_LEFT_SPACES=$(printf "%*s" $PADDING_LEFT "")

clear_logo() {
  local logo_content line

  printf "\033[H\033[2J" # Clear screen and move cursor to top-left

  if [[ -n ${OMANIRI_INSTALL_LOGO:-} ]]; then
    logo_content=$OMANIRI_INSTALL_LOGO
  elif [[ -f $LOGO_PATH ]]; then
    logo_content=$(<"$LOGO_PATH")
  else
    return
  fi

  printf '\n'
  while IFS= read -r line || [[ -n $line ]]; do
    printf '%s\e[32m%s\e[0m\n' "$PADDING_LEFT_SPACES" "$line"
  done <<< "$logo_content"
}
