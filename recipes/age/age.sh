rname="age"
rver="1.2.1"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/FiloSottile/${rname}/archive/refs/tags/${rfile}"
rsha256="93bd89a16c74949ee7c69ef580d8e4cf5ce03e7d9c461b68cf1ace3e4017eef5"
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
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
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
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
