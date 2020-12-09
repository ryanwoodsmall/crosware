rname="svnkit"
rver="1.10.2"
rdir="${rname}-${rver}"
rfile="org.tmatesoft.svn_${rver}.standalone.nojna.zip"
rurl="https://www.svnkit.com/${rfile}"
rsha256="7cd800acd220d2675b3544e1ca63eb617776c6f155ebe91fbaf40941fdc51963"
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
