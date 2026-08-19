# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.92.0"
RUST_MAX_VER="1.95.0"
RUST_NEEDS_LLVM=1
LLVM_COMPAT=( 22 )

inherit llvm-r1 systemd cargo linux-info udev xdg desktop

DESCRIPTION="Utility and daemon for controlling ASUS laptop features"
HOMEPAGE="https://asus-linux.org https://github.com/OpenGamingCollective/asusctl"

VENDOR_TARBALL="vendor_${PN}_${PV}.tar.xz"

SRC_URI="
	https://github.com/OpenGamingCollective/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/reckor-usa/asusctl-gentoo-overlay/releases/download/asusctl-6.4.0/${VENDOR_TARBALL}
"

S="${WORKDIR}/${P}"

LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0 ISC LicenseRef-UFL-1.0 MIT MPL-2.0 OFL-1.1 Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0/6"
KEYWORDS="~amd64"
RESTRICT="mirror test"

IUSE="+acpi +gui X -openrc"

RDEPEND="
	!!sys-power/rog-core
	!!sys-power/asus-nb-ctrl
	>=sys-power/power-profiles-daemon-0.13
	acpi? ( sys-power/acpi_call )
	gui? (
		dev-libs/libayatana-appindicator
		sys-auth/seatd
	)
"

DEPEND="
	${RDEPEND}
	dev-libs/libusb:1
	media-libs/sdl2-gfx
	sys-apps/dbus
	!openrc? ( sys-apps/systemd:0= )
	openrc? ( || (
		sys-apps/openrc
		sys-apps/sysvinit
	) )
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}=
		llvm-core/llvm:${LLVM_SLOT}=
	')
"

BDEPEND="
	virtual/pkgconfig
"

src_unpack() {
	unpack "${P}.tar.gz"

	cd "${S}" || die
	unpack "${VENDOR_TARBALL}"
}

src_prepare() {
	require_configured_kernel

	local k_wrn_touch=""
	linux_chkconfig_present I2C_HID_CORE || k_wrn_touch="${k_wrn_touch}> CONFIG_I2C_HID_CORE not found, should be either built-in or built as module\n"
	linux_chkconfig_present I2C_HID_ACPI || k_wrn_touch="${k_wrn_touch}> CONFIG_I2C_HID_ACPI not found, should be either built-in or built as module\n"
	linux_chkconfig_present HID_ASUS || k_wrn_touch="${k_wrn_touch}> CONFIG_HID_ASUS not found, should be either built-in or built as module\n"
	linux_chkconfig_builtin PINCTRL_AMD || k_wrn_touch="${k_wrn_touch}> CONFIG_PINCTRL_AMD not found, must be built-in\n"
	[[ ${k_wrn_touch} != "" ]] && ewarn "\nKernel configuration issue(s), needed for touchpad support:\n\n${k_wrn_touch}"

	mkdir -p "${S}/.cargo" || die
	cp "${FILESDIR}/${P}-vendor_config" "${S}/.cargo/config.toml" || die

	if ! use gui; then
		perl -0pi -e '
			s/\n  "rog-control-center",//;
			s/default-members = \["asusctl", "asusd", "asus-shutdown", "asusd-user", "rog-control-center"\]/default-members = ["asusctl", "asusd", "asus-shutdown", "asusd-user"]/;
		' Cargo.toml || die
	fi

	default
	rust_pkg_setup
}

src_configure() {
	local myfeatures=()

	if use gui && use X; then
		myfeatures+=( rog-control-center/x11 )
	fi

	cargo_src_configure
}

src_compile() {
	cargo_gen_config
	cargo_src_compile
}

src_install() {
	dobin target/release/asusctl
	dobin target/release/asusd
	dobin target/release/asusd-user
	dobin target/release/asus-shutdown

	if use gui; then
		dobin target/release/rog-control-center

		domenu rog-control-center/data/org.opengamingcollective.rog-control-center.desktop

		insinto /usr/share/metainfo
		doins rog-control-center/data/org.opengamingcollective.rog-control-center.metainfo.xml

		insinto /usr/share/icons/hicolor/512x512/apps
		doins rog-control-center/data/rog-control-center.png
		doins data/icons/*.png

		insinto /usr/share/icons/hicolor/scalable/status
		doins data/icons/scalable/*.svg

		insinto /usr/share/rog-gui/layouts
		doins rog-aura/data/layouts/*.ron
	fi

	insinto /usr/lib/udev/rules.d
	newins data/asusd.rules 99-asusd.rules

	insinto /usr/share/dbus-1/system.d
	doins data/asusd.conf

	if ! use openrc; then
		systemd_dounit data/asusd.service
		systemd_dounit data/asus-shutdown.service
		systemd_douserunit data/asusd-user.service
	else
		die "OpenRC support is not implemented in this local 6.4.0 ebuild yet"
	fi

	if use acpi; then
		insinto /etc/modules-load.d
		doins "${FILESDIR}/90-acpi_call.conf"
	fi

	insinto /usr/share/asusd
	doins rog-aura/data/aura_support.ron
	doins -r rog-anime/data/anime

	insinto /usr/share/asusctl
	doins LICENSE

	keepdir /etc/asusd

	dodoc README.md MANUAL.md CHANGELOG.md
}

pkg_postinst() {
	xdg_icon_cache_update
	udev_reload

	elog "asusd is normally started through udev/systemd activation."
	elog "This ebuild installs asus-shutdown.service, required by upstream 6.4.x."
}

pkg_postrm() {
	xdg_icon_cache_update
	udev_reload
}
