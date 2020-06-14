#
# XXX - needs classpath and main func to bring in contrib jar
#       https://common-lisp.net/project/armedbear/doc/abcl-install-with-java.html#linux
#
rname="abcl"
rver="1.7.0"
rdir="${rname}-bin-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://common-lisp.net/project/armedbear/releases/${rver}/${rfile}"
rsha256="6d9e2a38a8cb618aefaeaa92a67973d6405f1ccc6b0352049b41ec6d6ce30c9c"
rreqs="rlwrap"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current\"' > \"${rprof}\"
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwcheckreqs_${rname}
  cwsourceprofile
  cwextract \"${rdlfile}\" \"${rtdir}\"
  echo '#!/bin/sh' > \"${ridir}/${rname}\"
  echo 'rlwrap -C ${rname} java -jar ${rtdir}/current/${rname}.jar \"\${@}\"' >> \"${ridir}/${rname}\"
  cwchmod \"755\" \"${ridir}/${rname}\"
  cwlinkdir_${rname}
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"
