# ADR-0006: Формат автоустановки — autoinstall.scm вместо Kickstart

Статус: Принят
Дата: 2026-11-24

## Контекст

ТЗ VM1 п.4 требует «создание шаблонов Kickstart для VM2–VM4». Kickstart —
формат anaconda (RHEL/Fedora-семейство). Установщик ALT Linux p10
(install2/alterator) не потребляет .ks: он потребляет Scheme-профиль
autoinstall.scm плюс фиксированный набор метаданных (vm-profile.scm,
pkg-groups.tar, install-scripts.tar), доставляемый по curl=<каталог>.
Это ограничение установщика целевой ветки ОС, а не выбор автора.

## Решение

Отклонение от буквального ТЗ зафиксировано: «Kickstart» в ТЗ читается как
«декларативный профиль автоустановки»; реализация — autoinstall.scm +
4 файла метаданных + install-scripts.tar (preinstall.d/postinstall.d).
Механика zero-touch (ai + curl, IPAPPEND 2 → BOOTIF, CGI-триггер
pxe-just-once, per-MAC LOCALBOOT) сохранена и доказана живьём.

## Последствия

Положительные: работает в p10 без анаконды; цепочка прозрачна (ADR-0003).
Отрицательные: буквальное слово «kickstart» из ТЗ не реализуемо на этой ОС.
Митигация: терминологический мост «kickstart ≡ autoinstall.scm» указан
в README «Интерпретация» и в этом ADR; literal-имена служб/путей не
переводятся (ADR-0000).

## Related

ADR-0000 (процесс отклонений), ADR-0003 (Cobbler→dnsmasq, та же ветка
ограничений p10), README «Фаза 1 детально» / «Интерпретация».
