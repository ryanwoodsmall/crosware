rname="libconfig"
rver="1.7.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://hyperrealm.github.io/${rname}/dist/${rfile}"
rsha256="7c3c7a9c73ff3302084386e96f903eb62ce06953bb1666235fac74363a16fad9"
rreqs="make configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --disable-examples ${rconfigureopts} ${rcommonopts}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
