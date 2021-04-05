rname="kawa"
rver="3.1.1"
rdir="${rname}-${rver}"
rfile="${rdir}.zip"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="dab1f41da968191fc68be856f133e3d02ce65d2dbd577a27e0490f18ca00fa22"
# we need unzip, use the busybox version
rreqs="busybox"

. "${cwrecipe}/common.sh"

eval "
function cwmakeinstall_${rname}() {
  cwextract \"${rdlfile}\" \"${rtdir}\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'export KAWA_HOME=\"${rtdir}/current\"' > \"${rprof}\"
  echo 'append_path \"\${KAWA_HOME}/bin\"' >> \"${rprof}\"
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwsourceprofile
  cwcheckreqs_${rname}
  cwmakeinstall_${rname}
  cwlinkdir_${rname}
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"
