rname="age"
rver="1.0.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/FiloSottile/${rname}/archive/refs/tags/${rfile}"
rsha256="8d27684f62f9dc74014035e31619e2e07f8b56257b1075560456cbf05ddbcfce"
rreqs="go cacertificates"

. "${cwrecipe}/common.sh"

if [[ ${karch} =~ ^riscv64 ]] ; then
eval "
function cwinstall_${rname}() {
  cwscriptecho \"recipe ${rname} does not support architecture ${karch}\"
}
"
fi

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  test -e \"${rbdir}\" && chmod -R u+rw \"${rbdir}/\" || true
  rm -rf \"${rbdir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  : \${GOCACHE=\"${rbdir}/gocache\"}
  : \${GOMODCACHE=\"${rbdir}/gomodcache\"}
  mkdir -p build
  local p
  for p in ${rname}{,-keygen} ; do
    env \
      CGO_ENABLED=0 \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
        go build -x -ldflags '-s -w -extldflags \"-s -static\"' -o build/ \"${rbdir}/cmd/\${p}\"
  done
  unset p
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/share/man/man1\"
  cwmkdir \"${ridir}/share/doc\"
  local p
  for p in ${rname}{,-keygen} ; do
    install -m 0755 build/\${p} \"${ridir}/bin/\${p}\"
    install -m 0644 doc/\${p}.1 \"${ridir}/share/man/man1/\${p}.1\"
    install -m 0644 doc/\${p}.1.html \"${ridir}/share/doc/\${p}.1.html\"
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
