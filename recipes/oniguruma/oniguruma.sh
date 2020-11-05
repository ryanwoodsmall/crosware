rname="oniguruma"
rver="6.9.6"
rdir="onig-${rver//-*/}"
rfile="onig-${rver}.tar.gz"
rurl="https://github.com/kkos/${rname}/releases/download/v${rver//-/_}/${rfile}"
rsha256="bd0faeb887f748193282848d01ec2dad8943b5dfcb8dc03ed52dcc963549e819"
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
