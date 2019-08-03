rname="sisc"
rver="1.16.6"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://sourceforge.net/projects/${rname}/files/SISC/${rver}/${rfile}/download"
rsha256="65e15ac81d96e97de3ecabd409b3d2bc9307e624f46908d9f74047175c527ecf"
rreqs="rlwrap"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'export SISC_HOME=\"${rtdir}/current\"' > \"${rprof}\"
  echo 'append_path \"\${SISC_HOME}\"' >> \"${rprof}\"
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwcheckreqs_${rname}
  cwsourceprofile
  cwmkdir \"${rtdir}\"
  cwextract \"${rdlfile}\" \"${rtdir}\"
  cwlinkdir_${rname}
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"
