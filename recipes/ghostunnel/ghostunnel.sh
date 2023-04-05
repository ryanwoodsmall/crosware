rname="ghostunnel"
rver="1.7.1"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/${rname}/${rname}/archive/refs/tags/${rfile}"
rsha256="b4eced76660e5e4bcdead3a3026608d500576fac574e49371cf9de8c98041b71"
rreqs="go cacertificates"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  test -e \"\$(cwbdir_${rname})\" && chmod -R u+rw \"\$(cwbdir_${rname})/\" || true
  rm -rf \"\$(cwbdir_${rname})\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
  : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
  env \
    CGO_ENABLED=0 \
    GOCACHE=\"\${GOCACHE}\" \
    GOMODCACHE=\"\${GOMODCACHE}\" \
    PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
      go build -ldflags \"-s -w -extldflags '-s -static' -X main.version=\$(cwver_${rname})\" -o ${rname} .
  ./${rname} --help-custom-man > ${rname}.1
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  cwmkdir \"\$(cwidir_${rname})/share/man/man1\"
  install -m 0755 ${rname} \"\$(cwidir_${rname})/bin/${rname}\"
  install -m 0644 ${rname}.1 \"\$(cwidir_${rname})/share/man/man1/${rname}.1\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
