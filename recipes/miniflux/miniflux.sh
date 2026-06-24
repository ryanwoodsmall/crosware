#
# XXX - build a little client with miniflux.app/v2/client
# XXX - test with h2 postgres compat
#
rname="miniflux"
rver="2.3.1"
rdir="v2-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/miniflux/v2/archive/refs/tags/${rfile}"
rsha256="2cf82b224aba61dd8dddd60d7e850d3fdd06c1eaf4f1572aabb0818ec0a95ff2"
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
      CGO_ENABLED=0 \
        go build -ldflags '-s -w -extldflags \"-s -static\"' \"\$(cwbdir_${rname})/.\"
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  cwmkdir \"\$(cwidir_${rname})/share/man/man1\"
  install -m 0755 \"${rname}.app\" \"\$(cwidir_${rname})/bin/${rname}.app\"
  ln -sf \"${rname}.app\" \"\$(cwidir_${rname})/bin/${rname}\"
  install -m 0644 \"${rname}.1\" \"\$(cwidir_${rname})/share/man/man1/${rname}.1\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
