rname="glab"
rver="1.60.2"
rdir="cli-v${rver}"
rfile="${rdir}.tar.gz"
rurl="https://gitlab.com/gitlab-org/cli/-/archive/v${rver}/${rfile}"
rsha256="ef8265593d804f2dac2429e5bd92eedf498eac051d71a36180cba4b73f9b3d70"
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
        go build -ldflags \"-s -w -extldflags '-s -static' -X main.buildDate=\$(date +%Y-%m-%d) -X main.version=\$(cwver_${rname}) -X main.platform=linux -X main.debugMode=false\" -o \"${rname}\" \"\$(cwbdir_${rname})/cmd/${rname}\"
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 755 \"${rname}\" \"\$(cwidir_${rname})/bin/${rname}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
