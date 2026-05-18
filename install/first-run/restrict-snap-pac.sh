sudo sed -i '/^Operation = Install$/d; /^Operation = Remove$/d' \
  /usr/share/libalpm/hooks/05-snap-pac-pre.hook \
  /usr/share/libalpm/hooks/zz-snap-pac-post.hook
sudo sed -i 's|/usr/share/libalpm/scripts/snap-pac post|/bin/true|' \
  /usr/share/libalpm/hooks/zz-snap-pac-post.hook
echo "Done - pre snapshots only on Upgrade"
