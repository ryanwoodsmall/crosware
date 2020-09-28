rname="libatomicops"
rver="7.6.10"
rdir="libatomic_ops-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/ivmai/libatomic_ops/releases/download/v${rver}/${rfile}"
rsha256="587edf60817f56daf1e1ab38a4b3c729b8e846ff67b4f62a6157183708f099af"
rreqs="make configgit"

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
