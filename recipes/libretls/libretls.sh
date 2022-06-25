rname="libretls"
rver="3.5.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://causal.agency/${rname}/${rfile}"
rsha256="59ce9961cb1b1a2859cacb9863eeccc3bbeadf014840a1c61a0ac12ad31bcc9e"
rreqs="make openssl slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    CPPFLAGS=\"-I${cwsw}/openssl/current/include\" \
    LDFLAGS=\"-L${cwsw}/openssl/current/lib -static\" \
    LIBS=\"-lssl -lcrypto\" \
    PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"
