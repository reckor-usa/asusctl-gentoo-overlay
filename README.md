# ASUSCTL Gentoo Overlay

Personal Gentoo overlay for newer `sys-power/asusctl` builds, focused on ASUS ProArt P16 / H7606WX support.

## Current package

- `sys-power/asusctl-6.3.8`
- Built from `OpenGamingCollective/asusctl`
- Tested on ASUS ProArt P16 H7606WX
- systemd setup
- GUI enabled through `rog-control-center`
- No `supergfxctl` / `gfx` integration

## Recommended USE flags

`sys-power/asusctl X acpi gui -openrc`

## Tested status

Working locally on Gentoo with:

- `asusd.service`
- `asus-shutdown.service`
- `asusd-user.service`
- `asusctl info`
- battery limit
- profile control
- keyboard LED brightness
- `rog-control-center`

## Important note

The vendored Rust source tarball must be available before this overlay can be used by other machines.

For public use, the ebuild `SRC_URI` should point to a downloadable release asset, not a local `file:///var/cache/distfiles/...` path.
