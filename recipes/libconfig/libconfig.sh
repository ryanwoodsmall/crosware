rname="libconfig"
rver="1.8"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://hyperrealm.github.io/${rname}/dist/${rfile}"
rsha256="051e15dd0e907c44905f317933f5487314f2a56e8c6726c8304ce990884850aa"
rreqs="make configgit slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --disable-examples ${rconfigureopts} ${rcommonopts}
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
