#
# XXX - ethtool support? no idea if it works
#
rname="minisnmpd"
rver="2.0"
rdir="${rname//is/i-s}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/troglobit/mini-snmpd/releases/download/v${rver}/${rfile}"
rsha256="851acf49a1a36356664af0a7a040fa31f75403eb26e03627eba188ee15d4854c"
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
