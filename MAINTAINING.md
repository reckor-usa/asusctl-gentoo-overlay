# Maintaining this overlay

This file documents the update workflow for future `asusctl` releases.

## Current package

- Package: `sys-power/asusctl`
- Version: `6.5.0`
- Upstream: `OpenGamingCollective/asusctl`
- Crate archive: `asusctl-6.5.0-crates.tar.xz`
- Crate generation: `pycargoebuild --write-crate-tarball`
- Previous version: `6.4.0` retained as fallback
- Release tag: `asusctl-6.5.0`

## Update checklist

When upstream releases a new version:

1. Verify the upstream source tag, Rust requirements, Cargo.lock, and licenses.
2. Generate the crate archive using `pycargoebuild` and verify its contents.
3. Adapt the ebuild, dependencies, USE flags, and installation rules.
4. Update the Manifest and run `pkgcheck`.
5. Compile and install-test using an isolated QA overlay.
6. Back up the installed version before testing on hardware.
7. Validate system services, hardware settings, and the GUI.
8. Update the README and maintenance notes.
9. Complete human-controlled Git staging, commit, and push.
10. Create the release tag from the committed version and publish the GitHub Release.
11. Upload the crate archive to that release.
12. Verify public fetches and checksums using a clean DISTDIR.

The 6.5.0 ebuild excludes the obsolete `asusd-user` binary and service.
Do not restore those installation rules without validating upstream changes.

The 6.4.0 ebuild retains its original custom vendor archive and is not
converted retroactively. OpenRC support remains deferred.

## Notes from 6.3.8

- `asusctl --version` changed; use `asusctl info`.
- `rog-control-center` is the GUI, not Armoury Crate.
- `gfx`, `gnome`, and OpenRC integration are intentionally not enabled for the tested ProArt P16 setup.
- Old user Aura configurations could crash the legacy `asusd-user.service`; 6.5.0 no longer packages that service.
