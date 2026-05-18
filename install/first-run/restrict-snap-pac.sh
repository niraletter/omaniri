sudo sed -i '/^Operation = Install$/d; /^Operation = Remove$/d' \
  /usr/share/libalpm/hooks/05-snap-pac-pre.hook \
  /usr/share/libalpm/hooks/zz-snap-pac-post.hook
echo "Done - snapshots only on Upgrade now"
