rname="libatomicops"
rver="7.8.4"
rdir="libatomic_ops-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/ivmai/libatomic_ops/releases/download/v${rver}/${rfile}"
rsha256="2356e002e80ef695875e971d6a4fd8c61ca5c6fa4fd1bf31cce54a269c8bfcd5"
rreqs="make configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts}
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_cppflags \"-I${rtdir}/current/include\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
