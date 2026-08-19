# Maintaining this overlay

This file documents the update workflow for future `asusctl` releases.

## Current package

- Package: `sys-power/asusctl`
- Version: `6.4.0`
- Upstream: `OpenGamingCollective/asusctl`
- Vendor tarball: `vendor_asusctl_6.4.0.tar.xz`
- Release tag: `asusctl-6.4.0`

## Update checklist

When upstream releases a new version:

1. Copy the existing ebuild to the new version.
2. Download the upstream source tag.
3. Regenerate the Rust vendor tarball.
4. Update `VENDOR_TARBALL` and `SRC_URI` if needed.
5. Regenerate the Manifest.
6. Compile-test with `ebuild ... clean compile`.
7. Install-test locally.
8. Upload the new vendor tarball as a GitHub Release asset.
9. Test fetching from a clean temporary `DISTDIR`.
10. Commit, tag, push, and document the result.

## Notes from 6.3.8

- `asusctl --version` changed; use `asusctl info`.
- `rog-control-center` is the GUI, not Armoury Crate.
- `gfx` and `gnome` are intentionally not enabled for the tested ProArt P16 setup.
- Old user Aura config may crash `asusd-user.service`; neutral config is safer on H7606WX.
