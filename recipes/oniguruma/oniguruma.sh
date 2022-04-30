rname="oniguruma"
rver="6.9.8"
#rdir="onig-${rver//-*/}"
#rdir="onig-${rver%.1}"
rdir="onig-${rver}"
rfile="onig-${rver}.tar.gz"
#rurl="https://github.com/kkos/${rname}/releases/download/v${rver//-/_}/${rfile}"
rurl="https://github.com/kkos/${rname}/releases/download/v${rver}/${rfile}"
rsha256="28cd62c1464623c7910565fb1ccaaa0104b2fe8b12bcd646e81f73b47535213e"
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
