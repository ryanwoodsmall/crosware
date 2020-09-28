rname="iperf3"
rver="3.8.1"
rdir="iperf-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/esnet/${rname}/archive/${rfile}"
rsha256="4cf3aaf1fc881be2c443adddb1047b30c337d8ed975ce8134495fe2a5e09b7ea"
rreqs="make openssl configgit"

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
