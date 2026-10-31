rname="libconfig"
rver="1.8.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://hyperrealm.github.io/libconfig/dist/${rfile}"
rsha256="0ed3e37db12e38b6fd7ca85775283412043069da2edcdb0c0ddcf9160a5dcc71"
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
