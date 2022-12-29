#
# XXX - tree 2.x.x available, need to test against pass: http://mama.indstate.edu/users/ice/tree/changes.html
# XXX - moving to gitlab: https://gitlab.com/OldManProgrammer/unix-tree
# XXX - github mirror: https://github.com/Old-Man-Programmer/tree
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
