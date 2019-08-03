rname="svnkit"
rver="1.10.1"
rdir="${rname}-${rver}"
rfile="org.tmatesoft.svn_${rver}.standalone.nojna.zip"
rurl="https://www.svnkit.com/${rfile}"
rsha256="5d63a0e18f8751502e933f1a9e735a89fd1a94df19c264605a470c0ec3bbfaff"
# we need unzip, use the busybox version
rreqs="busybox"

. "${cwrecipe}/common.sh"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"${rtdir}\"
  cwextract \"${rdlfile}\" \"${rtdir}\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
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
