# Solve common flakiness with SSH.
# Use a dedicated drop-in (overwritten on re-run) instead of appending to the
# shared 99-sysctl.conf, which would duplicate the setting on every install.
echo "net.ipv4.tcp_mtu_probing=1" | sudo tee /etc/sysctl.d/99-omaniri-ssh.conf >/dev/null
