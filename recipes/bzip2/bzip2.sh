rname="bzip2"
rver="1.0.6"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://www.bzip.org/${rver}/${rfile}"
rsha256="a2848f34fcd5d6cf47def00461fcb528a0484d8edef8208d6d2e2909dc61d9cd"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG \"/^PREFIX=/ s#PREFIX=.*#PREFIX=${ridir}#g\" Makefile
  sed -i \"/^CFLAGS=/ s#CFLAGS=#CFLAGS=-Wl,-static -fPIC #g\" Makefile
  sed -i \"/^LDFLAGS=/ s#LDFLAGS=#LDFLAGS=-static #g\" Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
