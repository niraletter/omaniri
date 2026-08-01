omaniri_log_to_stdout() {
  [[ ${OMANIRI_LOG_TO_STDOUT:-} == "1" || -z ${OMANIRI_INSTALL_LOG_FILE:-} ]]
}

omaniri_log_line() {
  if omaniri_log_to_stdout; then
    echo "$1"
  else
    echo "$1" >>"$OMANIRI_INSTALL_LOG_FILE"
  fi
}

start_install_log() {
  if ! omaniri_log_to_stdout; then
    mkdir -p "$(dirname "$OMANIRI_INSTALL_LOG_FILE")"
    touch "$OMANIRI_INSTALL_LOG_FILE"
    chmod 666 "$OMANIRI_INSTALL_LOG_FILE" 2>/dev/null || true
  fi

  export OMANIRI_START_TIME="${OMANIRI_START_TIME:-$(date '+%Y-%m-%d %H:%M:%S')}"
  export OMANIRI_START_EPOCH="${OMANIRI_START_EPOCH:-$(date +%s)}"

  omaniri_log_line "=== Omaniri Setup Started: $OMANIRI_START_TIME ==="
}

stop_install_log() {
  local end_time end_epoch duration mins secs
  end_time=$(date '+%Y-%m-%d %H:%M:%S')
  end_epoch=$(date +%s)

  omaniri_log_line "=== Omaniri Setup Completed: $end_time ==="

  if [[ -n ${OMANIRI_START_EPOCH:-} ]]; then
    duration=$((end_epoch - OMANIRI_START_EPOCH))
    mins=$((duration / 60))
    secs=$((duration % 60))
    omaniri_log_line "Omaniri setup: ${mins}m ${secs}s"
  fi
}

run_logged() {
  local script="$1"
  local exit_code errexit_was_set=0

  omaniri_log_line "[$(date '+%Y-%m-%d %H:%M:%S')] Starting: $script"

  case $- in
    *e*)
      errexit_was_set=1
      set +e
      ;;
  esac

  local runner=(bash -eE)
  if [[ ${OMANIRI_INSTALL_DEBUG:-} == "1" ]]; then
    runner=(bash -x -eE)
  fi

  if omaniri_log_to_stdout; then
    PS4='+ ${BASH_SOURCE[0]##*/}:${LINENO}:${FUNCNAME[0]:-main}: ' \
      "${runner[@]}" -c 'source "$1"' bash "$script" </dev/null 2>&1
  else
    PS4='+ ${BASH_SOURCE[0]##*/}:${LINENO}:${FUNCNAME[0]:-main}: ' \
      "${runner[@]}" -c 'source "$1"' bash "$script" </dev/null >>"$OMANIRI_INSTALL_LOG_FILE" 2>&1
  fi

  exit_code=$?
  (( errexit_was_set )) && set -e

  if (( exit_code == 0 )); then
    omaniri_log_line "[$(date '+%Y-%m-%d %H:%M:%S')] Completed: $script"
  else
    omaniri_log_line "[$(date '+%Y-%m-%d %H:%M:%S')] Failed: $script (exit code: $exit_code)"
  fi

  return $exit_code
}
