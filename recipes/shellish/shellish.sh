#
# XXX - detect and test ${CW_GIT_CMD} and modify install/upgrade procedure to use a local clone
#
rname="shellish"
rver="d739fb0d4ea2c6c932283f668f7aebb6ad4da39a"
rdir="${rname//ish/-ish}-${rver}"
rfile="${rver}.zip"
#rurl="https://github.com/ryanwoodsmall/${rname//ish/-ish}/archive/refs/heads/${rfile}"
rurl="https://codeload.github.com/ryanwoodsmall/shell-ish/zip/${rver}"
rsha256=""
rreqs="htermutils"

if ! command -v less &>/dev/null ; then
  rreqs="${rreqs} busybox"
fi

. "${cwrecipe}/common.sh"

cwstubfunc "cwclean_${rname}"
cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwfetch_${rname}() {
  cwfetch \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\"
}
"

eval "
function cwextract_${rname}() {
  rm -rf \"\$(cwidir_${rname})/\$(cwdir_${rname})\" || true
  cwextract \"\$(cwdlfile_${rname})\" \"\$(cwidir_${rname})\"
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"\$(cwidir_${rname})/bin\"
  pushd \"\$(cwidir_${rname})\" &>/dev/null
  local p
  for p in box-utils.sh c256s chode coltotal dingafter dingsleep filesizetype.sh ht mixcase.sh nll procdirs.sh revnl revnll trl tru vim9p ymdhms.sh ; do
    ln -sf \"${rtdir}/current/\$(cwdir_${rname})/bin/\${p}\" \"\$(cwidir_${rname})/bin/\${p}\"
  done
  unset p
  rm -rf shell-ish-master
  ln -sf shell-ish-\$(cwver_${rname}) shell-ish-master
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
