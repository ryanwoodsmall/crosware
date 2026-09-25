rname="slib"
rver="3c3"
rdir="${rname}-${rver}"
rbdir="${cwbuild}/${rname}"
rfile="${rdir}.zip"
rurl="http://groups.csail.mit.edu/mac/ftpdir/scm/${rfile}"
rsha256="75de909ba42f1af2d1ac036eb52a2c7c6be62e61ec0d452809455390da08d942"
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
