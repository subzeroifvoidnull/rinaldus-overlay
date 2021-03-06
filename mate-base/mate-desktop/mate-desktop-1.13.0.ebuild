# Copyright open-overlay 2015 by Alex

EAPI="5"

GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

PYTHON_COMPAT=( python2_7 )

inherit gnome2 multilib python-r1 versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="Libraries for the MATE desktop that are not part of the UI"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

IUSE="X startup-notification gtk3"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.34:2
	x11-libs/cairo:0
	!gtk3? ( >=x11-libs/gdk-pixbuf-2.4:2
	>=x11-libs/gtk+-2.24:2
	>=dev-libs/libunique-1:1
        )
        gtk3? ( x11-libs/gtk+:3
        dev-libs/libunique:3
        ) 	
        x11-libs/libX11:0
	>=x11-libs/libXrandr-1.2:0
	virtual/libintl:0
	startup-notification? ( >=x11-libs/startup-notification-0.5:0 )"

DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/yelp-tools:0
	>=dev-util/intltool-0.50.2-r1
	>=gnome-base/dconf-0.10:0
	sys-devel/gettext:*
	>=x11-proto/randrproto-1.2:0
	x11-proto/xproto:0
	virtual/pkgconfig:*"

src_configure() {
        local myconf
        use gtk3 && myconf="${myconf} --with-gtk=3.0"
        use !gtk3 && myconf="${myconf} --with-gtk=2.0"
 	gnome2_src_configure \
		--enable-mate-about \
		--enable-mate-conf-import \
		--disable-desktop-docs \
		$(use_with X x) \
		$(use_enable startup-notification) \
                ${myconf}
}

DOCS="AUTHORS ChangeLog HACKING NEWS README"

src_install() {
	gnome2_src_install

	# Remove installed files that cause collissions.
	rm -rf "${ED}"/usr/share/help/C/{lgpl,gpl,fdl}
}
