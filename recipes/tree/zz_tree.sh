#
# XXX - tree 2.x.x available, changes: http://mama.indstate.edu/users/ice/tree/changes.html
# XXX - pass needs a later git commit for tree 2.x compat
# XXX - official site: http://oldmanprogrammer.net/source.php?dir=projects/tree
# XXX - gitlab mirror: https://gitlab.com/OldManProgrammer/unix-tree
# XXX - old/original site: http://mama.indstate.edu/users/ice/tree/
#
rname="tree"
rtreever="1"
rver="$(cwver_${rname}${rtreever})"
rdir="$(cwdir_${rname}${rtreever})"
rbdir="$(cwbdir_${rname}${rtreever})"
rfile="$(cwfile_${rname}${rtreever})"
rdlfile="$(cwdlfile_${rname}${rtreever})"
rurl="$(cwurl_${rname}${rtreever})"
rsha256="$(cwsha256_${rname}${rtreever})"
rreqs="${rname}${rtreever}"

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
  ln -sf \"\$(cwidir_${rname}${rtreever})\" \"\$(cwdir_${rname})\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

unset rtreever
