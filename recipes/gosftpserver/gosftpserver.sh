rname="gosftpserver"
rver="1.13.5"
rdir="sftp-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/pkg/sftp/archive/refs/tags/${rfile}"
rsha256="c7317ec28d40a2db47c099bd1eff8a72f31dd1cb8d4ce6a84379e15dfd4922a9"
rreqs="go"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  chmod -R u+rw \"\$(cwdir_${rname})\" &>/dev/null || true
  rm -rf \"${rbdir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
  : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
  env \
    CGO_ENABLED=0 \
    GOCACHE=\"\${GOCACHE}\" \
    GOMODCACHE=\"\${GOMODCACHE}\" \
    PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
      go build -ldflags '-s -w -extldflags \"-s -static\"' -o ${rname} \"\$(cwbdir_${rname})/server_standalone/\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/sbin\"
  install -m 755 ${rname} \"\$(cwidir_${rname})/sbin/${rname}\"
  ln -sf ${rname} \"\$(cwidir_${rname})/sbin/go-sftp-server\"
  ln -sf ${rname} \"\$(cwidir_${rname})/sbin/sftp-server\"
  popd >/dev/null 2>&1
}
"
