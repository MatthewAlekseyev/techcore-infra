# Фаза 1: zero-touch PXE для ALT p10 — механизм и грабли

## Рубильники
A automatic=method:http,network:dhcp,server:…,directory:/alt-p10  — stage без меню методов
B ai curl=http://…/kickstarts  — 4 файла метаданных с ФИКСИРОВАННЫМИ именами:
  autoinstall.scm, vm-profile.scm, pkg-groups.tar, install-scripts.tar
C триггер: IPAPPEND 2 -> BOOTIF в cmdline -> trigger.sh (preinstall.d/postinstall.d/laststate)
  -> CGI /trigger/installed -> per-MAC карточка LOCALBOOT

## Грабли (документированные источники)
- Ключ автоустановки: `ai` + `curl=<каталог>/`, НЕ `autoinstall=<файл>`.
- Эталон APPEND брать из isolinux.cfg самого ISO: lowmem, ramdisk_size=514073 (= altinst_KB+1).
- p10 после 10.05.2023: после `control close` обязательна строка `/remount-destination`.
- Имя скрипта пакетов: pkg-init (10.2), pkg-install-init (10.4+).
- pkg-groups.tar брать с диска из /Metadata/; группа = файл в lists/, имя в `lists "…"`.
- install-scripts.tar не требует alterator-postinstall; laststate — требует.

## VirtualBox-specific
iPXE-ром VBox НЕ выполняет LOCALBOOT (0 и -2): "Could not boot image: 0x7f8d81fe".
В лаборатории цикл рвёт порядок загрузки disk->net (пустой диск падает в PXE).
На реальном PXE-роме per-MAC карточка LOCALBOOT — штатный механизм.
