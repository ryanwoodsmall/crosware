rname="libconfig"
rver="1.7.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://hyperrealm.github.io/${rname}/dist/${rfile}"
rsha256="545166d6cac037744381d1e9cc5a5405094e7bfad16a411699bcff40bbb31ee7"
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
