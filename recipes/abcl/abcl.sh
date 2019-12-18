#
# XXX - needs classpath and main func to bring in contrib jar
#       https://common-lisp.net/project/armedbear/doc/abcl-install-with-java.html#linux
#
rname="abcl"
rver="1.6.0"
rdir="${rname}-bin-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://common-lisp.net/project/armedbear/releases/${rver}/${rfile}"
rsha256="2d8fc65db80afee81cce96f332ef6a6048294687a14c01e4c93d8a89f04c7bf2"
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
