# Track if we're already handling an error to prevent double-trapping
ERROR_HANDLING=false

# Cursor is usually hidden while we install
show_cursor() {
  printf "\033[?25h"
}

# Display truncated log lines from the install log
show_log_tail() {
  if [[ ! -f $OMANIRI_INSTALL_LOG_FILE ]]; then
    return
  fi

  local log_lines=$((TERM_HEIGHT - LOGO_HEIGHT - 35))
  local max_line_width=$((LOGO_WIDTH - 4))

  if (( log_lines < 5 )); then
    log_lines=5
  elif (( log_lines > 30 )); then
    log_lines=30
  fi

  while IFS= read -r line; do
    if ((${#line} > max_line_width)); then
      line="${line:0:$max_line_width}..."
    fi
    printf '%s%s  → %s\e[0m\n' "$PADDING_LEFT_SPACES" "\e[90m" "$line"
  done < <(tail -n $log_lines "$OMANIRI_INSTALL_LOG_FILE" 2>/dev/null)

  echo
}

# Display the failed command or script name
show_failed_script_or_command() {
  if [[ -n ${CURRENT_SCRIPT:-} ]]; then
    printf '%sFailed script: %s\e[0m\n' "$PADDING_LEFT_SPACES" "$CURRENT_SCRIPT"
  else
    # Truncate long command lines to fit the display
    local cmd="$BASH_COMMAND"
    local max_cmd_width=$((LOGO_WIDTH - 4))

    if ((${#cmd} > max_cmd_width)); then
      cmd="${cmd:0:$max_cmd_width}..."
    fi

    printf '%s%s\e[0m\n' "$PADDING_LEFT_SPACES" "$cmd"
  fi
}

# Save original stdout and stderr for trap to use
save_original_outputs() {
  exec 3>&1 4>&2
}

# Restore stdout and stderr to original (saved in FD 3 and 4)
# This ensures output goes to screen, not log file
restore_outputs() {
  if [[ -e /proc/self/fd/3 ]] && [[ -e /proc/self/fd/4 ]]; then
    exec 1>&3 2>&4
  fi
}

# Error handler
catch_errors() {
  # Prevent recursive error handling
  if [[ $ERROR_HANDLING == "true" ]]; then
    return
  else
    ERROR_HANDLING=true
  fi

  # Store exit code immediately before it gets overwritten
  local exit_code=$?

  stop_log_output
  restore_outputs

  clear_logo
  show_cursor

  printf '\n%s\e[31momaniri installation stopped!\e[0m\n\n' "$PADDING_LEFT_SPACES"
  show_log_tail

  printf '%sThis command halted with exit code %s:\e[0m\n' "$PADDING_LEFT_SPACES" "$exit_code"
  show_failed_script_or_command

  # Offer options menu
  while true; do
    options=()

    # If online install, show retry first
    if [[ -n ${OMANIRI_ONLINE_INSTALL:-} ]]; then
      options+=("Retry installation")
    fi

    # Add upload option if internet is available
    if ping -c 1 -W 1 1.1.1.1 >/dev/null 2>&1; then
      options+=("Upload log for support")
    fi

    # Add remaining options
    options+=("View full log")
    options+=("Exit")

    printf '\n%sWhat would you like to do?\n' "$PADDING_LEFT_SPACES"
    PS3="${PADDING_LEFT_SPACES}> "
    choice=
    select choice in "${options[@]}"; do
      if [[ -n $choice ]]; then
        break
      fi
    done

    case "$choice" in
    "Retry installation")
      bash ~/.local/share/omaniri/install.sh
      break
      ;;
    "View full log")
      if command -v less &>/dev/null; then
        less "$OMANIRI_INSTALL_LOG_FILE"
      else
        tail "$OMANIRI_INSTALL_LOG_FILE"
      fi
      ;;
    "Upload log for support")
      omaniri-upload-log
      ;;
    "Exit" | "")
      exit 1
      ;;
    esac
  done
}

# Exit handler - ensures cleanup happens on any exit
exit_handler() {
  local exit_code=$?

  # Only run if we're exiting with an error and haven't already handled it
  if (( exit_code != 0 )) && [[ $ERROR_HANDLING != "true" ]]; then
    catch_errors
  else
    stop_log_output
    show_cursor
  fi
}

# Set up traps
trap catch_errors ERR INT TERM
trap exit_handler EXIT

# Save original outputs in case we trap
save_original_outputs
