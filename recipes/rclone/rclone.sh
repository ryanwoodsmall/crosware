#
# XXX - rclone 1.62.x moved to fuse3, chromeos is currently fuse2
# XXX - results in failed mounts missing fusermount3 on PATH
# XXX - ugh, ugh
#

rname="rclone"
rver="1.67.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/${rname}/${rname}/archive/refs/tags/${rfile}"
rsha256="4ecf2e99eb98c9bb678be5b0cd28550c4a2a2d63b5f2ed66962a4f4b9b36c402"
rreqs="go"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  test -e \"${rbdir}\" && chmod -R u+rw \"${rbdir}\" || true
  rm -rf \"${rbdir}\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
    : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
    env \
      CGO_ENABLED=0 \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
        \"${cwsw}/go/current/bin/go\" build -ldflags \"-s -X github.com/rclone/rclone/fs.Version=\$(cwver_${rname}) -w -extldflags '-s -static'\"
    cwmkdir \"\$(cwidir_${rname})/bin\"
    cwmkdir \"\$(cwidir_${rname})/share/man/man1\"
    install -m 755 ${rname} \"\$(cwidir_${rname})/bin/${rname}\"
    install -m 644 ${rname}.1 \"\$(cwidir_${rname})/share/man/man1/${rname}.1\"
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
