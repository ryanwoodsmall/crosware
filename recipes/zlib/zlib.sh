rname="zlib"
rver="1.2.11"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="https://zlib.net/${rfile}"
rurl="https://sources.voidlinux.org/${rdir}/${rfile}"
rsha256="c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env CFLAGS=\"\${CFLAGS} -fPIC\" ./configure ${cwconfigureprefix} --static
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' > \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
