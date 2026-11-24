#!/bin/bash
# ADR-0004: native-валидация конфига ДО применения и ДО публичного коммита.
# Запускается на lab-prov-01. Не чинит — только проверяет и говорит, где болит.
set -uo pipefail
fail=0
check() { # $1=описание $2=команда
  if eval "$2" >/dev/null 2>&1; then printf '  OK   %s\n' "$1"
  else printf '  FAIL %s  ->  %s\n' "$1" "$2"; fail=1; fi
}
echo "== phase1 preflight (ADR-0004) =="
check "dnsmasq config"        "dnsmasq --test"
check "httpd2 config"         "/usr/sbin/httpd2 -t"
check "nftables ruleset"      "nft -c -f /etc/nftables/nftables.nft"
check "pxelinux default"      "grep -q APPEND /var/lib/tftpboot/pxelinux.cfg/default"
check "metadata: autoinstall" "[ -s /var/www/html/kickstarts/autoinstall.scm ]"
check "metadata: vm-profile"  "[ -s /var/www/html/kickstarts/vm-profile.scm ]"
check "metadata: pkg-groups"  "[ -s /var/www/html/kickstarts/pkg-groups.tar ]"
check "metadata: scripts-tar" "[ -s /var/www/html/kickstarts/install-scripts.tar ]"
check "trigger CGI exec"      "[ -x /var/www/html/trigger/installed ]"
check "stage binaries present" "[ -s /var/lib/tftpboot/alt-p10/vmlinuz ] && [ -s /var/lib/tftpboot/alt-p10/initrd.img ] && [ -s /var/www/html/alt-p10/altinst ]"
if [ "$fail" = 0 ]; then echo "PREFLIGHT GREEN"; else echo "PREFLIGHT RED — не рестартуй и не коммить (ADR-0004)"; fi
exit $fail
