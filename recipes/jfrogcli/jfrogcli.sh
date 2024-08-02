rname="jfrogcli"
rver="2.62.1"
rdir="jfrog-cli-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/jfrog/jfrog-cli/archive/refs/tags/${rfile}"
rsha256="4b76fdb7b0f4e11bcd383dfe6ac0b01747916f936227445bd916c97f6bd9b8ca"
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
    ${cwsw}/go/current/bin/go mod tidy || true
    env \
      CGO_ENABLED=0 \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
        go build -ldflags '-s -w -extldflags \"-s -static\"' -o jf
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 755 jf \"\$(cwidir_${rname})/bin/jf\"
  ln -sf jf \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf jf \"\$(cwidir_${rname})/bin/jfrog-cli\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
