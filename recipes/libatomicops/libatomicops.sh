rname="libatomicops"
rver="7.6.4"
rdir="libatomic_ops-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/ivmai/libatomic_ops/releases/download/v${rver}/${rfile}"
rsha256="5b823d5a685dd70caeef8fc50da7d763ba7f6167fe746abca7762e2835b3dd4e"
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
  echo 'append_cppflags \"-I${rtdir}/current/include\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
