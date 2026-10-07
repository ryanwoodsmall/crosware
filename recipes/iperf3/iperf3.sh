rname="iperf3"
rver="3.22"
rdir="iperf-${rver}"
#rfile="${rdir}.tar.gz"
#rurl="https://github.com/esnet/iperf/releases/download/${rver}/${rfile}"
rfile="${rver}.tar.gz"
rurl="https://github.com/esnet/iperf/archive/refs/tags/${rfile}"
rsha256="4dc1bc31ef4a4018973a6f543a3229fab020b20b26229bc7a40ed6779e367699"
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
