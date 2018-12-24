#!/bin/sh
set -e

/bin/echo "start: $(date)" >> /var/log/alpine_sync.log

# make sure we never run 2 rsync at the same time
lockfile="/tmp/alpine-mirror.lock"
if [ -z "$flock" ] ; then
  exec env flock=1 flock -n $lockfile $0 "$@"
fi

src=rsync://rsync.alpinelinux.org/alpine/ 
dest=/var/lib/nginx/html/alpinemirror/alpine/

/usr/bin/rsync -v -prua \
    --exclude-from /root/mirroring/alpine_exclude.txt \
    --delete \
    --timeout=120 \
    --delay-updates \
    --delete-after \
    "$src" "$dest"

/bin/echo "finish: $(date)" >> /var/log/alpine_sync.log
/bin/echo "###############################" >> /var/log/alpine_sync.log
