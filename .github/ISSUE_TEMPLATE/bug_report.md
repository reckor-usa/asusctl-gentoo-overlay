---
name: Bug report
about: Report an issue with this Gentoo overlay or ebuild
title: "[bug] "
labels: bug
assignees: ""
---

## System

- Laptop model:
- Board name:
- Gentoo profile:
- Kernel version:
- systemd or OpenRC:
- `asusctl` version:
- USE flags:

## Problem

Describe the issue.

## Commands/output

Please include:

    asusctl info
    asusctl battery info
    asusctl profile get
    systemctl status asusd.service --no-pager -l
    journalctl -u asusd.service -b --no-pager -n 120

## Notes

Add any extra context here.
