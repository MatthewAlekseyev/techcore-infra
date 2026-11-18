# ADR-0005: Distro-специфичные факты узнавать из системы, а не из туториалов

Статус: Принят
Дата: 2026-11-11

## Контекст

ALT Linux расходится с RHEL/Debian-туториалами в именах пакетов, служб,
бинарников и путей:

- apache2 разрезан на apache2-base, apache2-mods, apache2-httpd-worker
  (монолитного пакета apache2 нет);
- служба httpd2, бинарник /usr/sbin/httpd2;
- /etc/openssh вместо /etc/ssh;
- /etc/net/ifaces вместо NetworkManager;
- /etc/nftables/nftables.nft вместо /etc/nftables.conf;
- раскладка установочного ISO нестандартная;
- decoy-имена ahttpd, vhttpd содержат httpd, но не являются Apache.

Предположения из туториалов приводят к тихим сбоям.

## Решение

Документация, туториалы, память и прошлые чаты (включая ответы ассистента)
трактуются как гипотезы низшего уровня доверия: они дают только список
кандидатов для проверки. Факты берутся из системы:

- rpm -q, rpm -qa | grep, rpm -ql, rpm -qf
- systemctl cat, systemctl show -p FragmentPath -p ExecStart -p Environment
- бинарник с -v, -V, -t
- grep по конфигу (DocumentRoot, CustomLog, ErrorLog, Include, User, Group)
- lsblk, blkid, ss -tlnp, ss -ulnp, lsmod, getenforce

Расхождение слоёв (пакет говорит одно, диск другое, runtime третье) — это
не «ну ладно», а запись в troubleshooting: кто-то правил руками, пакет
осиротел или юнит leftover.

## Последствия

Положительные:

- репозиторий становится evidence-based;
- навык отладки переносится на любой дистрибутив;
- готовый ответ на собесе «как вы отлаживаете неизвестный хост».

Отрицательные:

- больше проверочных команд.

Митигация:

- bootstrap-чеклист из четырёх команд для неизвестного хоста;
- preflight-скрипт кодирует повторяющиеся проверки.
