#
# XXX - ethtool support? no idea if it works
#
rname="minisnmpd"
rver="2.1"
rdir="${rname//is/i-s}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/troglobit/mini-snmpd/releases/download/v${rver}/${rfile}"
rsha256="2f9936e4c62d1469a13e43611001b6ac36901ddb9809e3c7cb2297830615a6a1"
rreqs="make pkgconf libconfuse ethtool"

. "${cwrecipe}/common.sh"

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
