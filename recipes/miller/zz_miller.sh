rname="miller"
rmillerver="6"
rver="$(cwver_${rname}${rmillerver})"
rdir="$(cwdir_${rname}${rmillerver})"
rbdir="$(cwbdir_${rname}${rmillerver})"
rfile="$(cwfile_${rname}${rmillerver})"
rdlfile="$(cwdlfile_${rname}${rmillerver})"
rurl="$(cwurl_${rname}${rmillerver})"
rsha256="$(cwsha256_${rname}${rmillerver})"
rreqs="${rname}${rmillerver}"

. "${cwrecipe}/common.sh"

for f in fetch clean extract patch configure make ; do
  cwstubfunc "cw${f}_${rname}"
done
unset f

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"${rtdir}\"
  pushd \"${rtdir}\" >/dev/null 2>&1
  test -e \"\$(cwdir_${rname})\" && rm -f \"\$(cwdir_${rname})\" || true
  ln -sf \"\$(cwidir_${rname}${rmillerver})\" \"\$(cwdir_${rname})\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

unset rmillerver
