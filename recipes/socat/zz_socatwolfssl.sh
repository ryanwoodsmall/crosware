#
# XXX - issues with dtls, don't use this
#

rname="socatwolfssl"
rver="1.7.4.1"
rdir="wolfssl-osp-socat-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/wolfssl/osp/${rfile}"
rsha256="ba4aa74ec7280712c1d76303d3d5135fc8a517c81a526877242c8a9fd79899a7"
rreqs="make wolfssl netbsdcurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --with-wolfssl=\"${cwsw}/wolfssl/current\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
      LIBS='-lreadline -lcurses -lterminfo -static -s' \
      PKG_CONFIG_{LIBDIR,PATH}=
  echo '#define NETDB_INTERNAL (-1)' >> compat.h
  sed -i 's#netinet/if_ether#linux/if_ether#g' sysincludes.h
  echo '#undef HAVE_GETPROTOBYNUMBER_R' >> config.h
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install
  ln -sf socat \"${ridir}/bin/${rname}\"
  ln -sf socat \"${ridir}/bin/socat-wolfssl\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
