#
# XXX - rlwrap completions example here: https://armedbear.common-lisp.dev/doc/abcl-install-with-java.html
#
rname="abcl"
rver="1.9.1"
rdir="${rname}-bin-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://common-lisp.net/project/armedbear/releases/${rver}/${rfile}"
rsha256="79d2f16de734d4edf137077a2aeb9cba21e128343577abc2ec16eb330ccfb419"
rreqs="rlwrap"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})\"
  tar -cf - . | ( cd \"\$(cwidir_${rname})\" ; tar -xf - )
  echo '#!/bin/sh' > \"\$(cwidir_${rname})/${rname}\"
  echo 'rlwrap -C ${rname} java -cp ${rtdir}/current/${rname}.jar:${rtdir}/current/${rname}-contrib.jar org.armedbear.lisp.Main \"\${@}\"' >> \"\$(cwidir_${rname})/${rname}\"
  cwchmod \"755\" \"\$(cwidir_${rname})/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current\"' > \"${rprof}\"
}
"
