rname="gosftpserver"
rver="1.13.7"
rdir="sftp-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/pkg/sftp/archive/refs/tags/${rfile}"
rsha256="e48cee5bbf57777264c30d3aea0063d978c8321a7a261cba05f04a6c339dd9c8"
rreqs="go"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  chmod -R u+rw \"\$(cwdir_${rname})\" &>/dev/null || true
  rm -rf \"${rbdir}\"
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
    : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
    env \
      CGO_ENABLED=0 \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
        go build -ldflags '-s -w -extldflags \"-s -static\"' -o ${rname} \"\$(cwbdir_${rname})/server_standalone/\"
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/sbin\"
  install -m 755 ${rname} \"\$(cwidir_${rname})/sbin/${rname}\"
  ln -sf ${rname} \"\$(cwidir_${rname})/sbin/go-sftp-server\"
  ln -sf ${rname} \"\$(cwidir_${rname})/sbin/sftp-server\"
  popd &>/dev/null
}
"
