rname="iperf3"
rver="3.9"
rdir="iperf-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/esnet/${rname}/archive/${rfile}"
rsha256="c6d8076b800f2b51f92dc941b0a9b77fbf2a867f623b5cb3cbf4754dabc40899"
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
