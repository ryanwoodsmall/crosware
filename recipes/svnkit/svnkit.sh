rname="svnkit"
rver="1.9.1"
rurl="https://www.svnkit.com/org.tmatesoft.svn_${rver}.standalone.nojna.zip"
rfile="$(basename ${rurl})"
rdir="${rname}-${rver}"
rsha256="ff86d6470d3bc0ab546f60db3f3c7547721aa155da26e2d82d82e1c713cfec57"
rprof="${cwetcprofd}/${rname}.sh"
# we need unzip, use the busybox version
rreqs="busybox"

. "${cwrecipe}/common.sh"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir "${cwsw}/${rname}"
  test -e "${cwsw}/${rname}/${rdir}" && mv "${cwsw}/${rname}/${rdir}"{,.PRE-${TS}}
  unzip -o "${cwdl}/${rfile}" -d "${cwsw}/${rname}"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/${rname}/current/bin\"' >> "${rprof}"
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwsourceprofile
  cwcheckreqs_${rname}
  cwmakeinstall_${rname}
  cwlinkdir "${rdir}" "${cwsw}/${rname}"
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"
