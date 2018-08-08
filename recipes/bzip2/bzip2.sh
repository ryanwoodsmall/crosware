rname="bzip2"
rver="1.0.6"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/ryanwoodsmall/${rname}/archive/${rfile}"
rsha256="1a8b3a69c92ac300121f37be9d40409c36d783b5914d9b695856e83256cdad0f"
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
