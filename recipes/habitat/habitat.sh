#
# XXX - other architectures maybe incoming...
# XXX - need a way to check the latest version
#

rname="habitat"
rver="1.6.500.20220509205350"
rdir="${rname}-${rver}"
rfile="core-hab-${rver%.*}-${rver##*.}-x86_64-linux.hart"
rurl="https://bldr.habitat.sh/v1/depot/pkgs/core/hab/${rver%.*}/${rver##*.}/download?target=x86_64-linux"
rsha256="2e5539abacf488b97ecab88fad631570f3f13546b7aadcf376138af980959cb0"
rreqs=""

. "${cwrecipe}/common.sh"

if [[ ! ${karch} =~ ^x86_64$ ]] ; then
eval "
function cwinstall_${rname}() {
  cwscriptecho \"${rname} not supported on ${uarch}\"
}
"
fi

for f in make configure ; do
  eval "
  function cw${f}_${rname}() {
    true
  }
  "
done
unset f

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  rm -rf "${rname}" hab
  popd >/dev/null 2>&1
}
"

eval "
function cwextract_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  tail -n +6 \"${rdlfile}\" | xzcat -dc | tar -xf -
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"${ridir}/bin\"
  install -m 0755 \"${cwbuild}/hab/pkgs/core/hab/${rver%.*}/${rver##*.}/bin/hab\" \"${ridir}/bin/hab\"
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
