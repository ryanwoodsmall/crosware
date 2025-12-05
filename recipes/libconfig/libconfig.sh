rname="libconfig"
rver="1.8.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://hyperrealm.github.io/libconfig/dist/${rfile}"
rsha256="c73ee3d914ec68c99b61e864832931e9a7112eeabfb449dad217fd83e385cbdf"
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
