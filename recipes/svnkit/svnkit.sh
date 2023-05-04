rname="svnkit"
rver="1.10.10"
rdir="${rname}-${rver}"
rfile="org.tmatesoft.svn_${rver}.standalone.nojna.zip"
rurl="https://www.svnkit.com/${rfile}"
rsha256="e4f9b91874c70f11c4380d0b256a1cb8aa9d1089c75a40b54d415c4723c2b224"
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
