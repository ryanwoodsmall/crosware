rname="libretls"
rver="3.8.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://causal.agency/${rname}/${rfile}"
rsha256="3bc9fc0e61827ee2f608e5e44993a8fda6d610b80a1e01a9c75610cc292997b5"
rreqs="make openssl slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    CPPFLAGS=\"-I${cwsw}/openssl/current/include\" \
    LDFLAGS=\"-L${cwsw}/openssl/current/lib -static\" \
    LIBS=\"-lssl -lcrypto\" \
    PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"
