rname="oniguruma"
rver="6.9.1"
rdir="onig-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/kkos/${rname}/releases/download/v${rver}/${rfile}"
rsha256="c7c3feb7be45a5cc9f2dec239b4a317a422e6ffea299cf91ffab1b926633ea12"
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
