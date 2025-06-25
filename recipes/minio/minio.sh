rname="minio"
rver="2025-06-13T11-33-47Z"
rcommitid="a6c538c5a113a588d49b4f3af36ae3046cfa5ac6"
rdir="minio-RELEASE.${rver}"
rfile="RELEASE.${rver}.tar.gz"
rurl="https://github.com/minio/minio/archive/refs/tags/${rfile}"
rsha256=""
rreqs="go miniomc"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"
cwechofunc "cwcommitid_${rname}" "${rcommitid}"

unset rcommitid

eval "
function cwfetch_${rname}() {
  cwfetch \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\"
}
"

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
  local l=''
  local c=\"\$(cwcommitid_${rname})\"
  local s=\"\${c:0:12}\"
  local y=\"\$(cwver_${rname} | cut -f1 -d-)\"
  l+=\" -X github.com/minio/minio/cmd.CopyrightYear=\${y} \"
  l+=\" -X github.com/minio/minio/cmd.ReleaseTag=RELEASE.\$(cwver_${rname}) \"
  l+=\" -X github.com/minio/minio/cmd.Version=\$(cwver_${rname}) \"
  l+=\" -X github.com/minio/minio/cmd.CommitID=\${c} \"
  l+=\" -X github.com/minio/minio/cmd.ShortCommitID=\${s} \"
  l+=\" -X github.com/minio/minio/cmd.GOPATH= \"
  l+=\" -X github.com/minio/minio/cmd.GOROOT= \"
  (
    : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
    : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
    env \
      CGO_ENABLED=0 \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
      MINIO_RELEASE=RELEASE \
        go build -trimpath -tags kqueue -ldflags \"-s -w -extldflags '-s -static' \${l}\" -o \"${rname}\"
  )
  unset l c s y
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 755 \"${rname}\" \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname}-server\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
