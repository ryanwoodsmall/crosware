rname="iperf3"
rver="3.19"
rdir="iperf-${rver}"
#rfile="${rdir}.tar.gz"
#rurl="https://github.com/esnet/iperf/releases/download/${rver}/${rfile}"
rfile="${rver}.tar.gz"
rurl="https://github.com/esnet/iperf/archive/refs/tags/${rfile}"
rsha256="da5cff29e4945b2ee05dcf9a0c67768cc000dc1b122935bce3492c4e36f6b5e9"
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
