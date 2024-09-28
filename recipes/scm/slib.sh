rname="slib"
rver="3c1"
rdir="${rname}-${rver}"
rbdir="${cwbuild}/${rname}"
rfile="${rdir}.zip"
rurl="http://groups.csail.mit.edu/mac/ftpdir/scm/${rfile}"
rsha256="c2f8eb98e60530df53211985d4b403b6e97a7a969833c1a6d1bf83561da0c781"
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
