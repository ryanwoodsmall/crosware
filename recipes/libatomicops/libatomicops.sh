rname="libatomicops"
rver="7.8.0"
rdir="libatomic_ops-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/ivmai/libatomic_ops/releases/download/v${rver}/${rfile}"
rsha256="15676e7674e11bda5a7e50a73f4d9e7d60452271b8acf6fd39a71fefdf89fa31"
rreqs="make configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
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
