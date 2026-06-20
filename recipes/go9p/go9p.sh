rname="go9p"
rver="0.25.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/knusbaum/go9p/archive/refs/tags/${rfile}"
rsha256="4bdc50130feb5fcd171561017b8eb91675817a4a449fb26425d666d1979540eb"
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
    for p in 9cert {export,import,mount}9p ; do
      env \
        CGO_ENABLED=0 \
        GOCACHE=\"\${GOCACHE}\" \
        GOMODCACHE=\"\${GOMODCACHE}\" \
        PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
          go build -ldflags '-s -w -extldflags \"-s -static\"' -o \"\${p}\" \"\$(cwbdir_${rname})/cmd/\${p}/.\"
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
  for p in 9cert {export,import,mount}9p ; do
    install -m 755 \"\${p}\" \"\$(cwidir_${rname})/bin/\${p}\"
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
