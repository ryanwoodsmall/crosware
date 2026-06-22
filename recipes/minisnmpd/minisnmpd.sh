#
# XXX - ethtool support? no idea if it works
#
rname="minisnmpd"
rver="1.7"
rdir="${rname//is/i-s}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/troglobit/${rdir%-*}/releases/download/v${rver}/${rfile}"
rsha256="bf119818276cd63e37d29d4c5e88f8cdf2975113bc9a2a39ee2b3a91f66de20a"
rreqs="make pkgconf libconfuse ethtool"

. "${cwrecipe}/common.sh"

cwappendfunc \
  "cwfetch_${rname}" \
  "cwfetchcheck https://github.com/troglobit/mini-snmpd/raw/refs/tags/v\$(cwver_${rname})/ethtool-conf.h ${cwdl}/${rname}/ethtool-conf.h 3b3c0cf9fc7df375dbd0c949b40ed644413c7c448cb37dde206f2c77f0a20629"

cwappendfunc "cwextract_${rname}" "install -m 0644 ${cwdl}/${rname}/ethtool-conf.h \$(cwbdir_${rname})/ethtool-conf.h"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} \
    --enable-ethtool \
    --with-config \
    --without-systemd \
      CPPFLAGS=\"-I${cwsw}/libconfuse/current/include\" \
      LDFLAGS=\"-L${cwsw}/libconfuse/current/lib -static\" \
      PKG_CONFIG=\"${cwsw}/pkgconf/current/bin/pkgconf\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"${cwsw}/libconfuse/current/lib/pkgconfig\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"

# vim: set ft=bash:
