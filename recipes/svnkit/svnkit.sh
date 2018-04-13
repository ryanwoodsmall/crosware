rname="svnkit"
rver="1.9.2"
rurl="https://www.svnkit.com/org.tmatesoft.svn_${rver}.standalone.nojna.zip"
rfile="$(basename ${rurl})"
rdir="${rname}-${rver}"
rsha256="cced9cbdee0f64f0eef0163be0511065a1a95dc7f234b1741133142dd760e618"
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
  cwlinkdir "${rdir}" "${rtdir}"
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"
