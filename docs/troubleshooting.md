# TechCore Troubleshooting Log

Файл фиксирует реальные сбои, их диагностику и правило, извлечённое из случая.
Стиль: симптом → причина → лечение → урок. Каждый случай связан с ADR.

---

## 2026-11-11: rpm говорит apache2 not installed, но httpd2.service существует

Симптом: `package apache2 is not installed`, при этом list-unit-files показывает
httpd.service, httpd2.service, ahttpd.socket.
Причина: в ALT Apache разрезан на суб-пакеты apache2-base, apache2-mods,
apache2-httpd-worker; монолитного пакета apache2 нет. ahttpd и vhttpd — не Apache,
grep ловит их по подстроке httpd (имена-обманки).
Диагностика: `rpm -qa | grep -iE 'httpd|apache'`; `rpm -ql apache2-base | grep
'^/etc'`; `rpm -ql apache2-httpd-worker | grep -E '/sbin/|systemd|^/var/log'`;
`systemctl show httpd2.service -p FragmentPath -p ExecStart -p Environment`.
Урок: см. ADR-0005 — имена пакетов/служб/бинарников брать из rpm и systemctl,
а не из RHEL/Debian-туториалов; дизамбигуацию делать через rpm -qf владельца.

---

## Профилактическое правило: мина stateful-фаервола против TFTP

Симптом-паттерн: PXE-клиент получает IP, шлёт RRQ за pxelinux.0, но данные до
клиента не долетают; экран чёрный; в dnsmasq.log после RRQ тишина (нет sent).
Причина: TFTP принимает запрос на udp 69, а отвечает данными с плавающих эфемерных
портов; stateful-фаервол default-deny без парсера не связывает ответ с запросом и
дроппает первый DATA-блок. DHCP иммунитет, потому что его ответ идёт с фиксированной
пары 67→68.
Проверка: `lsmod | grep nf_conntrack_tftp`.
Лечение: `modprobe nf_conntrack_tftp` и закрепление в /etc/modules-load.d/; как
вторая линия — tftp-portrange в dnsmasq и явное правило nft на диапазон.
Урок: см. ADR-0002; эту мину нельзя поймать при написании конфига — она проявляется
только на живом тесте, поэтому проверяется до теста, а не после.
