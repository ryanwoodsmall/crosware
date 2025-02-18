#
# XXX - other architectures maybe incoming...
# XXX - need a way to check the latest version
#

rname="habitat"
rver="1.6.1243.20241227194506"
rdir="${rname}-${rver}"
rfile="core-hab-${rver%.*}-${rver##*.}-x86_64-linux.hart"
rurl="https://bldr.habitat.sh/v1/depot/pkgs/core/hab/${rver%.*}/${rver##*.}/download?target=x86_64-linux"
rsha256="1434113faef3fabaa81b48bc994eae652fd92dac83631f5194ca5558626eed17"
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
  pushd \"${cwbuild}\" &>/dev/null
  rm -rf \"${rname}\" hab
  popd &>/dev/null
}
"

eval "
function cwextract_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  tail -n +6 \"\$(cwdlfile_${rname})\" | xzcat -dc | tar -xf -
  popd &>/dev/null
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
  echo ': export HAB_LICENSE HAB_BINLINK_DIR' >> \"${rprof}\"
}
"
