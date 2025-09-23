#
# XXX - rename to "gostatic"
# XXX - requires go-misc change too
# XXX - generic go recipe w/CGO enabled
# XXX - date should be moved to version?
# XXX - set GOPATH/GOCACHE/GOMODCACHE/...???
# XXX - might may should possibly probably need to set GOTOOLCHAIN to "path" to avoid toolchain download?
# XXX - https://tip.golang.org/doc/toolchain
#
rname="go"
rgover="125"
rver="$(cwver_${rname}${rgover})"
rdir="$(cwdir_${rname}${rgover})"
rbdir="$(cwbdir_${rname}${rgover})"
rfile="$(cwfile_${rname}${rgover})"
rdlfile="$(cwdlfile_${rname}${rgover})"
rurl="$(cwurl_${rname}${rgover})"
rsha256="$(cwsha256_${rname}${rgover})"
rreqs="${rname}${rgover} cacertificates"

. "${cwrecipe}/common.sh"

for f in fetch clean extract patch configure make ; do
  cwstubfunc "cw${f}_${rname}"
done
unset f

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"${rtdir}\"
  pushd \"${rtdir}\" &>/dev/null
  test -e \"\$(cwdir_${rname})\" && rm -f \"\$(cwdir_${rname})\" || true
  ln -sf \"\$(cwidir_${rname}${rgover})\" \"\$(cwdir_${rname})\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

unset rgover
