rname="tea"
rver="0.11.1"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://gitea.com/gitea/${rname}/archive/${rfile}"
rsha256="1da6b6d2534bd6ffb0931400014bbdef26242cf4d35d4ba44c24928811825805"
rreqs="go"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwfetch_${rname}() {
  cwfetch \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\"
}
"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  chmod -R u+rw \"${rname}\" \"\$(cwdir_${rname})\" &>/dev/null || true
  rm -rf \"${rbdir}\"
  popd &>/dev/null
}
"

eval "
function cwextract_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  rm -rf \"${rname}\" \"\$(cwdir_${rname})\"
  cwextract \"\$(cwdlfile_${rname})\" \"${cwbuild}\"
  mv \"${rname}\" \"\$(cwdir_${rname})\"
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
        go mod vendor
    env \
      CGO_ENABLED=0 \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
        go build -ldflags '-s -w -extldflags \"-s -static\"' -o \"${rname}\"
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
