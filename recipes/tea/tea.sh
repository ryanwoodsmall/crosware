rname="tea"
rver="0.8.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://gitea.com/gitea/${rname}/archive/${rfile}"
rsha256="6c73c0a7b66cdfd1e5a302257d54df06a3a41eb9bdbfeb547966db431ae23b23"
rreqs="go"

. "${cwrecipe}/common.sh"

eval "function cwconfigure_${rname}() { true ; }"

eval "
function cwextract_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  rm -rf \"${rname}\" \"${rdir}\"
  cwextract \"${rdlfile}\" \"${cwbuild}\"
  mv \"${rname}\" \"${rdir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  : \${GOCACHE=\"${rbdir}/gocache\"}
  : \${GOMODCACHE=\"${rbdir}/gomodcache\"}
  env \
    CGO_ENABLED=0 \
    GOCACHE=\"\${GOCACHE}\" \
    GOMODCACHE=\"\${GOMODCACHE}\" \
    PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
      go build -x -mod=vendor -ldflags '-s -w -extldflags \"-s -static\"' -o \"${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  install -m 755 \"${rname}\" \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
