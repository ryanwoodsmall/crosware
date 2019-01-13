rname="libatomicops"
rver="7.6.8"
rdir="libatomic_ops-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/ivmai/libatomic_ops/releases/download/v${rver}/${rfile}"
rsha256="1d6a279edf81767e74d2ad2c9fce09459bc65f12c6525a40b0cb3e53c089f665"
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
