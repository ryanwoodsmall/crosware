rname="9pro"
rver="c66e91c68b28138da3ea4b761d63271591078414"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
#rfile="${rdir}.tar.gz"
#rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rurl="https://git.sr.ht/~ft/9pro/archive/${rfile}"
rsha256="08dd402e9c00314455e10d31d83ecbce2086478a6900756d859c7985135d035a"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cat Makefile > Makefile.ORIG
  sed -i '/CFLAGS.*=/s/$/ -Wl,-static -Wl,-s -g0/g' Makefile
  sed -i '/{CC} -o .*{COMMON_O}/s/$/ -g0 -static -s -Wl,-static -Wl,-s/g' Makefile
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env CC=\"\${CC}\" make 9pex 9gc
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 0755 9pex \"\$(cwidir_${rname})/bin/\"
  install -m 0755 9gc \"\$(cwidir_${rname})/bin/\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
