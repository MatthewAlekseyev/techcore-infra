#!/bin/sh
D=${destdir:-/}
M=
for x in $(cat /proc/cmdline 2>/dev/null); do
  case $x in BOOTIF=*) M=${x#BOOTIF=01-};; esac
done
if [ -z "$M" ]; then
  for n in /sys/class/net/*; do
    i=${n##*/}
    [ "$i" = "lo" ] && continue
    a=$(cat "$n/address" 2>/dev/null)
    case "$a" in ""|00:00:00:00:00:00) continue;; esac
    M=$(echo "$a" | tr ':' '-')
    break
  done
fi
{
  echo "ran: mac=$M destdir=$D"
  echo "cmdline: $(cat /proc/cmdline)"
  curl -sS "http://192.168.100.10/trigger/installed?mac=$M"
} > "$D/root/zt-trigger.log" 2>&1
exit 0
