#
# XXX - other architectures maybe incoming...
# XXX - need a way to check the latest version
#

rname="habitat"
rver="1.6.1041.20240411141804"
rdir="${rname}-${rver}"
rfile="core-hab-${rver%.*}-${rver##*.}-x86_64-linux.hart"
rurl="https://bldr.habitat.sh/v1/depot/pkgs/core/hab/${rver%.*}/${rver##*.}/download?target=x86_64-linux"
rsha256="8643e13d08693a4b6355fa85710acdb77816ea50bb8a79779152ff545461313e"
rreqs=""

. "${cwrecipe}/common.sh"

if [[ ! ${karch} =~ ^x86_64$ ]] ; then
eval "
function cwinstall_${rname}() {
  cwscriptecho \"${rname} not supported on ${uarch}\"
}
"
fi

cwstubfunc "cwmake_${rname}"
cwstubfunc "cwconfigure_${rname}"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  rm -rf \"${rname}\" hab
  popd >/dev/null 2>&1
}
"

eval "
function cwextract_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  tail -n +6 \"\$(cwdlfile_${rname})\" | xzcat -dc | tar -xf -
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 755 \"\$(find ${cwbuild}/hab/pkgs/core/hab/ -type f -name hab)\" \"\$(cwidir_${rname})/bin/hab\"
}
"

# XXX - HAB_LICENSE="accept-no-persist" ???
eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo ': \${HAB_LICENSE:=\"accept\"}' >> \"${rprof}\"
  echo ': \${HAB_BINLINK_DIR:=\"${rtdir}/current/bin\"}' >> \"${rprof}\"
  echo 'export HAB_LICENSE HAB_BINLINK_DIR' >> \"${rprof}\"
}
"
