rname="iperf3"
rver="3.19.1"
rdir="iperf-${rver}"
#rfile="${rdir}.tar.gz"
#rurl="https://github.com/esnet/iperf/releases/download/${rver}/${rfile}"
rfile="${rver}.tar.gz"
rurl="https://github.com/esnet/iperf/archive/refs/tags/${rfile}"
rsha256="85e480d7fffdcb1368888aaee9d76bcfc211e17c2a6dcb2060b281498f82c97b"
rreqs="make openssl configgit zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG 's/-pg//g' src/Makefile.in
  ./configure ${cwconfigureprefix} \
    --enable-static-bin \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
