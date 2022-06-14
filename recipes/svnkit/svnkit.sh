rname="svnkit"
rver="1.10.6"
rdir="${rname}-${rver}"
rfile="org.tmatesoft.svn_${rver}.standalone.nojna.zip"
rurl="https://www.svnkit.com/${rfile}"
rsha256="2776e85a835bd7534d5916a282df8486e6656c128724d559d73309e177bc178c"
# we need unzip, use the busybox version
rreqs=""
if ! command -v unzip &>/dev/null ; then
  rreqs="busybox"
fi

. "${cwrecipe}/common.sh"

cwstubfunc "cwclean_${rname}"
cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}() {
  cwextract \"\$(cwdlfile_${rname})\" \"${rtdir}\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
