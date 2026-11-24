# Фаза 1: zero-touch PXE для ALT p10 — механизм и грабли

## Рубильники
A  automatic=method:http,network:dhcp,server:192.168.100.10,directory:/alt-p10
   stage качается без меню методов. Эталон APPEND — из isolinux.cfg самого ISO:
   fastboot changedisk showopts vga=normal mpath lowmem ramdisk_size=<altinst_KB+1>.
B  ai curl=http://192.168.100.10/kickstarts  (БЕЗ слэша на конце)
   4 файла с фиксированными именами: autoinstall.scm, vm-profile.scm,
   pkg-groups.tar, install-scripts.tar. Дубль в /alt-p10/Metadata/ = fallback дока.
C  IPAPPEND 2 -> BOOTIF в cmdline -> trigger.sh (preinstall.d + postinstall.d +
   laststate) -> CGI /trigger/installed -> per-MAC карточка LOCALBOOT.
boot  в VirtualBox цикл рвёт порядок загрузки disk->net (пустой диск падает в PXE).

## Грабли (док 22 / wiki Autoinstall / wiki NetInstall)
- Ключ автоустановки: `ai` + `curl=<каталог>`, НЕ `autoinstall=<файл>`.
- p10 после 10.05.2023: после `control close` обязательна `/remount-destination`.
- Имя скрипта пакетов: pkg-init (10.2), pkg-install-init (10.4+).
- pkg-groups.tar брать с диска /Metadata/; своя группа = файл в lists/, имя в lists "...".
- install-scripts.tar не требует alterator-postinstall; laststate — требует.
- Числа в vm-profile.scm без кавычек, в 512-байтных блоках.
- computer_name без точки (altbug #27017).

## VirtualBox-specific
iPXE-ром VBox НЕ выполняет LOCALBOOT (0 и -2): "Could not boot image: 0x7f8d81fe".
В лаборатории цикл рвёт boot order disk->net. На реальном PXE-роме per-MAC карточка
LOCALBOOT — штатный механизм доков.

## Долги -> Фаза 2
1. Пароль plaintext в autoinstall.scm (читается по HTTP, уйдёт в git):
   mkpasswd --method=yescrypt -> iscrypted #t passwd_1 "$y$j9T$..." (док 22.1.3.5).
2. computer_name "zt-node" и name "enp0s3" статичны -> рендерер по MAC/IP
   из аренды dnsmasq (тот же CGI-паттерн, что триггер).
3. Три механизма триггера -> оставить install-scripts.tar.
