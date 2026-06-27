# Contributing

This is a personal Gentoo overlay focused on newer `sys-power/asusctl` builds.

Issues and pull requests are welcome, especially for:

- ASUS ProArt P16 / H7606WX testing
- newer `asusctl` versions
- Gentoo ebuild fixes
- better documentation
- confirmed behavior on other ASUS models

## Before opening an issue

Please include:

- laptop model
- board name
- Gentoo profile
- kernel version
- `asusctl info`
- relevant USE flags
- relevant `journalctl -u asusd.service` output

## Scope

This overlay is not an official Gentoo package and is not upstream `asusctl`.

The current tested target is ASUS ProArt P16 H7606WX on Gentoo with systemd.
