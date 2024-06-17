rname="age"
rver="1.2.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/FiloSottile/${rname}/archive/refs/tags/${rfile}"
rsha256="cefe9e956401939ad86a9c9d7dcf843a43b6bcdf4ee7d8e4508864f227a3f6f0"
rreqs="go cacertificates"

. "${cwrecipe}/common.sh"


cwstubfunc "cwconfigure_${rname}"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  test -e \"\$(cwbdir_${rname})\" && chmod -R u+rw \"\$(cwbdir_${rname})/\" || true
  rm -rf \"\$(cwbdir_${rname})\"
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
    : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
    mkdir -p build
    local p
    for p in ${rname}{,-keygen} ; do
      env \
        CGO_ENABLED=0 \
        GOCACHE=\"\${GOCACHE}\" \
        GOMODCACHE=\"\${GOMODCACHE}\" \
        PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
          go build -x -ldflags '-s -w -extldflags \"-s -static\"' -o build/ \"\$(cwbdir_${rname})/cmd/\${p}\"
    done
    unset p
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  cwmkdir \"\$(cwidir_${rname})/share/man/man1\"
  cwmkdir \"\$(cwidir_${rname})/share/doc\"
  local p
  for p in ${rname}{,-keygen} ; do
    install -m 0755 build/\${p} \"\$(cwidir_${rname})/bin/\${p}\"
    install -m 0644 doc/\${p}.1 \"\$(cwidir_${rname})/share/man/man1/\${p}.1\"
    install -m 0644 doc/\${p}.1.html \"\$(cwidir_${rname})/share/doc/\${p}.1.html\"
  done
  unset p
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
