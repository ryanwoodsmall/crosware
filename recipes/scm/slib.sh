rname="slib"
rver="3c2"
rdir="${rname}-${rver}"
rbdir="${cwbuild}/${rname}"
rfile="${rdir}.zip"
rurl="http://groups.csail.mit.edu/mac/ftpdir/scm/${rfile}"
rsha256="7906d8e201dc18e97945a61ac62ce792ec939b67d0bcc23073e0011ac2561a04"
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
