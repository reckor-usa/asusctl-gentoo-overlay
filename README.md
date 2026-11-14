# ASUSCTL Gentoo Overlay

Personal Gentoo overlay for newer `sys-power/asusctl` builds.

This overlay is currently focused on ASUS ProArt P16 / H7606WX support.

## Current package

- `sys-power/asusctl-6.5.0` (6.4.0 retained as fallback)
- Source: `OpenGamingCollective/asusctl`
- Tested on ASUS ProArt P16 H7606WX
- systemd setup
- GUI enabled through `rog-control-center`
- No `supergfxctl` / `gfx` integration

## Tested status

Confirmed working on ASUS ProArt P16 H7606WX with:

- `asusd.service`
- `asus-shutdown.service`
- `asusd-user.service` intentionally excluded from the 6.5.0 package
- `asusctl info`
- battery charge limit
- profile control
- keyboard LED brightness
- `rog-control-center`
- local 6.5.0 build, installation-image, hardware, and GUI tests

## Recommended USE flags

    sys-power/asusctl X acpi gui

This overlay intentionally does not enable `gfx` or `gnome`. The GUI is provided by `rog-control-center`; `gfx`/`gnome` are for `supergfxctl` integration, which is not required for the tested ProArt P16 setup.

## Install

Add the overlay with `eselect-repository`:

    eselect repository add asusctl-gentoo-overlay git https://github.com/reckor-usa/asusctl-gentoo-overlay.git
    emaint sync -r asusctl-gentoo-overlay

Add package USE flags:

    mkdir -p /etc/portage/package.use
    echo "sys-power/asusctl X acpi gui" >> /etc/portage/package.use/asusctl

Before upgrading from 6.4.0, disable the old user daemon as your normal
desktop user (not needed for a fresh installation):

    systemctl --user disable --now asusd-user.service

Install:

    emerge -av =sys-power/asusctl-6.5.0::asusctl-gentoo-overlay

## After install

Reload systemd and udev:

    systemctl daemon-reload
    udevadm control --reload-rules
    systemctl restart asusd.service
    systemctl enable --now asus-shutdown.service

Check status:

    asusctl info
    asusctl battery info
    asusctl profile get
    asusctl leds get
    systemctl status asusd.service --no-pager -l
    systemctl status asus-shutdown.service --no-pager -l

## User daemon migration

The 6.5.0 package deliberately excludes the `asusd-user` binary and user
service. The upstream component is being retired, and it repeatedly crashed
during local 6.5.0 testing. The system daemon and GUI work without it.

Existing installations should disable the old user service. The former
`~/.config/rog/rog-user.ron` Aura workaround applies only to legacy versions.

## Distfiles

The 6.5.0 ebuild uses the upstream source archive and a Rust crate archive
generated through `pycargoebuild`.

Release asset: `asusctl-6.5.0-crates.tar.xz`

SHA512:

    4d7181dcd71fd29cbfb39e72da6a5a37bc8ff655cc3d256201396d5f3be212b9ecf9d381b15b0d65dd0933c86bcc5e4882be2a350372ad2c50d20e599cb454aa

The retained 6.4.0 ebuild uses its original
`vendor_asusctl_6.4.0.tar.xz` archive.

## Maintenance status

This is a personal overlay, not an official Gentoo package and not upstream `asusctl`.
