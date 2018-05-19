rname="svnkit"
rver="1.9.3"
rurl="https://www.svnkit.com/org.tmatesoft.svn_${rver}.standalone.nojna.zip"
rfile="$(basename ${rurl})"
rdir="${rname}-${rver}"
rsha256="055e54e7909b7f7a57312d07c90b546d97d34c007e0d13f5c07b96960d4d559b"
# we need unzip, use the busybox version
rreqs="busybox"

. "${cwrecipe}/common.sh"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir "${rtdir}"
  test -e "${ridir}" && mv "${ridir}"{,.PRE-${TS}}
  unzip -o "${cwdl}/${rname}/${rfile}" -d "${rtdir}"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' >> "${rprof}"
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
