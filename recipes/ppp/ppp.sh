#
# XXX - move config to ${cwetc}/ppp
#
rtls="openssl"
rname="ppp"
rver="2.5.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://download.samba.org/pub/ppp/${rfile}"
rsha256="733b7f5840b613da4eab0429a5081293275f06ba8b528e1b8eea6964faf0243a"
rreqs="${rname}${rtls}"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  echo '#include <sys/types.h>' >> pppd/config.h.in
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"${rtdir}\"
  rm -rf \"${rtdir}/current\"
  rm -rf \"\$(cwidir_${rname})\"
  ln -sf \"\$(cwidir_${rname}${rtls})\" \"\$(cwidir_${rname})\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"

unset rtls
