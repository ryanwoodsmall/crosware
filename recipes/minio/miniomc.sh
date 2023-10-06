rname="miniomc"
rver="2023-09-29T16-41-22Z"
rcommitid="d47a2ba53a5e10cd1bc8b946c05f4cadb71d4ee3"
rdir="mc-RELEASE.${rver}"
rfile="RELEASE.${rver}.tar.gz"
rurl="https://github.com/minio/mc/archive/refs/tags/${rfile}"
rsha256=""
rreqs="go"

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
  pushd \"${cwbuild}\" >/dev/null 2>&1
  chmod -R u+rw \"\$(cwdir_${rname})\" \"${rbdir}\" &>/dev/null || true
  rm -rf \"${rbdir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  local l=''
  local c=\"\$(cwcommitid_${rname})\"
  local s=\"\${c:0:12}\"
  local y=\"\$(cwver_${rname} | cut -f1 -d-)\"
  l+=\" -X github.com/minio/mc/cmd.CopyrightYear=\${y} \"
  l+=\" -X github.com/minio/mc/cmd.ReleaseTag=RELEASE.\$(cwver_${rname}) \"
  l+=\" -X github.com/minio/mc/cmd.Version=\$(cwver_${rname}) \"
  l+=\" -X github.com/minio/mc/cmd.CommitID=\${c} \"
  l+=\" -X github.com/minio/mc/cmd.ShortCommitID=\${s} \"
  : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
  : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
  env \
    CGO_ENABLED=0 \
    GOCACHE=\"\${GOCACHE}\" \
    GOMODCACHE=\"\${GOMODCACHE}\" \
    PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
    MC_RELEASE=RELEASE \
      go build -trimpath -tags kqueue -ldflags \"-s -w -extldflags '-s -static' \${l}\" -o \"${rname}\"
  unset l c s y
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  cwmkdir \"\$(cwidir_${rname})/devbin\"
  install -m 755 \"${rname}\" \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname%mc}-client\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname%mc}-mc\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/devbin/mc\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
