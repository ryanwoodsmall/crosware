rname="goyq"
rver="4.34.2"
rdir="${rname#go}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/mikefarah/yq/archive/refs/tags/${rfile}"
rsha256="035b7e827eccc66907270ff7f0d35c7917d56ded4aff44f7b942fe4802b70d01"
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
      go build -ldflags '-s -w -extldflags \"-s -static\"' -o \"${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 755 \"${rname}\" \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rname}\" \"\$(cwidir_${rname})/bin/${rname#go}\"
  ln -sf \"${rname}\" \"\$(cwidir_${rname})/bin/go-${rname#go}\"
  ln -sf \"${rname}\" \"\$(cwidir_${rname})/bin/${rname#go}go\"
  ln -sf \"${rname}\" \"\$(cwidir_${rname})/bin/${rname#go}-go\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
