#
# XXX - needs classpath and main func to bring in contrib jar
#       https://common-lisp.net/project/armedbear/doc/abcl-install-with-java.html#linux
#
rname="abcl"
rver="1.6.1"
rdir="${rname}-bin-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://common-lisp.net/project/armedbear/releases/${rver}/${rfile}"
rsha256="076e1b60c7c0e74c3223a2e378184b8699d5cf7f6125831e3319d8a2b4ca5a6f"
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
