rname="svnkit"
rver="1.10.0"
rurl="https://www.svnkit.com/org.tmatesoft.svn_${rver}.standalone.nojna.zip"
rfile="$(basename ${rurl})"
rdir="${rname}-${rver}"
rsha256="e711bee3a8fa2adccf3b1024b9c6e74657e1ed5c04c7e24adebfbc59fb86576a"
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
