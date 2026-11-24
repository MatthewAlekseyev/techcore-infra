#!/bin/sh
# Пересборка pkg-groups.tar (база ISO + группа zt) и install-scripts.tar (триггер).
set -e
K=/var/www/html/kickstarts
PG=$(find /var/www/html/alt-p10 -name pkg-groups.tar | head -1)
W=/root/pg-work; rm -rf "$W"; mkdir -p "$W"; tar xf "$PG" -C "$W"
L=$(find "$W" -maxdepth 2 -type d -name lists | head -1)
printf 'alterator-postinstall\n' > "$L/zt"
( cd "$W" && tar cf "$K/pkg-groups.tar" groups lists )
B=/root/is-build; rm -rf "$B"; mkdir -p "$B/preinstall.d" "$B/postinstall.d"
\cp "$K/trigger.sh" "$B/preinstall.d/99-trigger.sh"
\cp "$K/trigger.sh" "$B/postinstall.d/99-trigger.sh"
chmod 755 "$B"/preinstall.d/* "$B"/postinstall.d/*
( cd "$B" && tar cf "$K/install-scripts.tar" preinstall.d postinstall.d )
chmod -R a+rX "$K"
