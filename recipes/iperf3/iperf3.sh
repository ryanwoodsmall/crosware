rname="iperf3"
rver="3.6"
rdir="iperf-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/esnet/${rname}/archive/${rfile}"
rsha256="1ad23f70a8eb4b892a3cbb247cafa956e0f5c7d8b8601b1d9c8031c2a806f23f"
rreqs="make openssl"

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
