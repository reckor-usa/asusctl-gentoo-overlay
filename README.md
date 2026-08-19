# ASUSCTL Gentoo Overlay

Personal Gentoo overlay for newer `sys-power/asusctl` builds.

This overlay is currently focused on ASUS ProArt P16 / H7606WX support.

## Current package

- `sys-power/asusctl-6.4.0`
- Source: `OpenGamingCollective/asusctl`
- Tested on ASUS ProArt P16 H7606WX
- systemd setup
- GUI enabled through `rog-control-center`
- No `supergfxctl` / `gfx` integration

## Tested status

Confirmed working on ASUS ProArt P16 H7606WX with:

- `asusd.service`
- `asus-shutdown.service`
- `asusd-user.service`
- `asusctl info`
- battery charge limit
- profile control
- keyboard LED brightness
- `rog-control-center`
- clean public overlay fetch test for 6.4.0

## Recommended USE flags

    sys-power/asusctl X acpi gui -openrc

This overlay intentionally does not enable `gfx` or `gnome`. The GUI is provided by `rog-control-center`; `gfx`/`gnome` are for `supergfxctl` integration, which is not required for the tested ProArt P16 setup.

## Install

Add the overlay with `eselect-repository`:

    eselect repository add asusctl-gentoo-overlay git https://github.com/reckor-usa/asusctl-gentoo-overlay.git
    emaint sync -r asusctl-gentoo-overlay

Add package USE flags:

    mkdir -p /etc/portage/package.use
    echo "sys-power/asusctl X acpi gui -openrc" >> /etc/portage/package.use/asusctl

Install:

    emerge -av =sys-power/asusctl-6.4.0::asusctl-gentoo-overlay

## After install

Reload systemd and udev:

    systemctl daemon-reload
    udevadm control --reload-rules
    systemctl restart asusd.service
    systemctl start asus-shutdown.service

Enable the user daemon:

    systemctl --user enable --now asusd-user.service

Check status:

    asusctl info
    asusctl battery info
    asusctl profile get
    asusctl leds get
    systemctl status asusd.service --no-pager -l
    systemctl status asus-shutdown.service --no-pager -l
    systemctl --user status asusd-user.service --no-pager -l

## Note about old user Aura config

On the tested ProArt P16, an old user config with active Aura animation caused `asusd-user.service` to crash because the laptop did not expose the expected direct Aura DBus object.

The safe user config was:

    (
        active_anime: None,
        active_aura: None,
    )

Stored at:

    ~/.config/rog/rog-user.ron

## Distfiles

This ebuild uses a vendored Rust dependency tarball hosted as a GitHub Release asset:

    vendor_asusctl_6.4.0.tar.xz

Manifest SHA512:

    7eb8392256c95c570fe1c3ee8237d2a0e03582eb03455614d26cebdc9d8a0d6b3904af0ce4651948e73bf10e1c80483ca769d950283e91ef376017c12d2fb4f0

## Maintenance status

This is a personal overlay, not an official Gentoo package and not upstream `asusctl`.
