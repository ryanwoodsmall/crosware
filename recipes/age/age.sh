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
  chmod -R u+rw \"${rbdir}/\" || true
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
  for p in ${rname}{,-keygen} ; do
    env \
      CGO_ENABLED=0 \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
        go build -x -ldflags '-s -w -extldflags \"-s -static\"' -o build/ \"${rbdir}/cmd/\${p}\"
  done
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  install -m 0755 build/${rname} \"${ridir}/bin/${rname}\"
  install -m 0755 build/${rname}-keygen \"${ridir}/bin/${rname}-keygen\"
  cwmkdir \"${ridir}/share/man/man1\"
  install -m 0644 doc/${rname}.1 \"${ridir}/share/man/man1/${rname}.1\"
  install -m 0644 doc/${rname}-keygen.1 \"${ridir}/share/man/man1/${rname}-keygen.1\"
  cwmkdir \"${ridir}/share/doc\"
  install -m 0644 doc/${rname}.1.html \"${ridir}/share/doc/${rname}.1.html\"
  install -m 0644 doc/${rname}-keygen.1.html \"${ridir}/share/doc/${rname}-keygen.1.html\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
