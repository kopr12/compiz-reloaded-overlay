# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )
DISTUTILS_IN_SOURCE_BUILD=1
inherit distutils-r1 git-r3 gnome2-utils

DESCRIPTION="A graphical manager for CompizConfig Plugin (libcompizconfig)"
HOMEPAGE="https://github.com/compiz-reloaded"
EGIT_REPO_URI="git://github.com/compiz-reloaded/ccsm.git"

LICENSE="GPL-2"
SLOT="0"
IUSE="gtk3"

RDEPEND="
	dev-python/pycairo[${PYTHON_USEDEP}]
	>=dev-python/compizconfig-python-${PV}[${PYTHON_USEDEP}]
	gnome-base/librsvg
	gtk3? (  dev-python/pygobject[${PYTHON_USEDEP}] )
	!gtk3? ( >=dev-python/pygtk-2.12:2[${PYTHON_USEDEP}] )
"

python_prepare_all() {
	# return error if wrong arguments passed to setup.py
	sed -i -e 's/raise SystemExit/\0(1)/' setup.py || die 'sed on setup.py failed'

	# correct gettext behavior
	if [[ -n "${LINGUAS+x}" ]] ; then
		for i in $(cd po ; echo *po | sed 's/\.po//g') ; do
		if ! has ${i} ${LINGUAS} ; then
			rm po/${i}.po || die
		fi
		done
	fi

	distutils-r1_python_prepare_all
}

python_configure_all() {
	mydistutilsargs=(
		build \
		--prefix=/usr \
		--with-gtk=$(usex gtk3 3.0 2.0)
	)
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}