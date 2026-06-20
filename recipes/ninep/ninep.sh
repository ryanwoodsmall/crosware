rname="ninep"
rver="93837e57744ea2f36b52cab16b37afaeb2bbeb06"
rdir="${rname}-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/gnoack/ninep/archive/${rfile}"
rsha256="63cc58557d8d65052148c0b863030e629cbdf365c55a29101743c3b462c99c22"
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
    for p in 9p{tool,web} ; do
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
  for p in 9p{tool,web} ; do
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
