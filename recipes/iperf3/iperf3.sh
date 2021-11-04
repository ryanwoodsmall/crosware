rname="iperf3"
rver="3.10.1"
rdir="iperf-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/esnet/${rname}/archive/${rfile}"
rsha256="6a4bb4d5c124b3fa64dfbda469ab16857ad6565310bcaa3dd8cd32f96c2fc473"
rreqs="make openssl configgit zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG 's/-pg//g' src/Makefile.in
  ./configure ${cwconfigureprefix}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
