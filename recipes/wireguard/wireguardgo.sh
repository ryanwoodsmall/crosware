#
# XXX - remove specific go version req below
#
rname="wireguardgo"
rver="0.0.20230223"
rdir="wireguard-go-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/WireGuard/wireguard-go/archive/refs/tags/${rfile}"
rsha256="c679fff905cbd097836d280c99c1b86454264921951491716b235e162178263a"
rgover="122"
rreqs="bootstrapmake go${rgover} wireguardtools"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  test -e \"${rbdir}\" && chmod -R u+rw \"${rbdir}\" || true
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
      PATH=\"${cwsw}/go${rgover}/current/bin:\${PATH}\" \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      GOPATH=\"\$(cwbdir_${rname})/gopath\" \
      GOROOT=\"${cwsw}/go${rgover}/current\" \
      CGO_ENABLED=0 \
        make PREFIX=\"\$(cwidir_${rname})\"
    chmod -R u+rw . || true
  )
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
      PATH=\"${cwsw}/go${rgover}/current/bin:\${PATH}\" \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      GOPATH=\"\$(cwbdir_${rname})/gopath\" \
      GOROOT=\"${cwsw}/go${rgover}/current\" \
      CGO_ENABLED=0 \
        make install PREFIX=\"\$(cwidir_${rname})\"
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

unset rgover
