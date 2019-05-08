rname="oniguruma"
rver="6.9.2"
rdir="onig-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/kkos/${rname}/releases/download/v${rver}/${rfile}"
rsha256="db7addb196ecb34e9f38d8f9c97b29a3e962c0e17ea9636127b3e3c42f24976a"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
