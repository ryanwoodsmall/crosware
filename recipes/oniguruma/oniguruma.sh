rname="oniguruma"
rver="6.8.2"
rdir="onig-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/kkos/${rname}/releases/download/v${rver}/${rfile}"
rsha256="adeada5f6b54c2a6f58ff021831a01b18a62b55ea9935e972e36ebb19e7c4903"
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
