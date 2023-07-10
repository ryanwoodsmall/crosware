#
# XXX - rlwrap completions example here: https://armedbear.common-lisp.dev/doc/abcl-install-with-java.html
#
rname="abcl"
rver="1.9.2"
rdir="${rname}-bin-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://common-lisp.net/project/armedbear/releases/${rver}/${rfile}"
rsha256="24970976b3565ddf32a1e0b17c5034a9996df25404ec44f240505b01c68a37fe"
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
