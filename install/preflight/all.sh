source $OMANIRI_INSTALL/preflight/guard.sh
source $OMANIRI_INSTALL/preflight/begin.sh
run_logged $OMANIRI_INSTALL/preflight/show-env.sh
run_logged $OMANIRI_INSTALL/preflight/pacman.sh
run_logged $OMANIRI_INSTALL/preflight/aur.sh
run_logged $OMANIRI_INSTALL/preflight/first-run-mode.sh
run_logged $OMANIRI_INSTALL/preflight/disable-mkinitcpio.sh
