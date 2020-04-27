rname="oniguruma"
rver="6.9.5-rev1"
rdir="onig-${rver//-*/}"
rfile="onig-${rver}.tar.gz"
rurl="https://github.com/kkos/${rname}/releases/download/v${rver//-/_}/${rfile}"
rsha256="d33c849d1672af227944878cefe0a8fcf26fc62bedba32aa517f2f63c314a99e"
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
