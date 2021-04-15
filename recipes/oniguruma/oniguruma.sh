rname="oniguruma"
rver="6.9.7.1"
#rdir="onig-${rver//-*/}"
rdir="onig-${rver%.1}"
rfile="onig-${rver}.tar.gz"
rurl="https://github.com/kkos/${rname}/releases/download/v${rver//-/_}/${rfile}"
rsha256="6444204b9c34e6eb6c0b23021ce89a0370dad2b2f5c00cd44c342753e0b204d9"
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
