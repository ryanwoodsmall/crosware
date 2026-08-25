rname="jacal"
rver="2a1"
rdir="${rname}-${rver}"
rbdir="${cwbuild}/${rname}"
rfile="${rdir}.zip"
rurl="http://groups.csail.mit.edu/mac/ftpdir/scm/${rfile}"
rsha256="f2fd9e82ce16eb9a92514991c6a8500ecc72662d75977064e17a28687d0236a9"
rreqs=""

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})\"
  tar -cf - . | ( cd \"\$(cwidir_${rname})\" ; tar -xf - )
  popd &>/dev/null
}
"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  rm -rf ${rname}
  popd &>/dev/null
}
"
