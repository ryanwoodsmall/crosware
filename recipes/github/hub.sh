rname="hub"
rver="2.14.2"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/github/${rname}/archive/refs/tags/${rfile}"
rsha256="e19e0fdfd1c69c401e1c24dd2d4ecf3fd9044aa4bd3f8d6fd942ed1b2b2ad21a"
rreqs="go"

if ! $(command -v git &>/dev/null) ; then
  rreqs="${rreqs} git"
fi

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  : \${GOCACHE=\"${rbdir}/gocache\"}
  : \${GOMODCACHE=\"${rbdir}/gomodcache\"}
  mkdir -p build
  env \
    CGO_ENABLED=0 \
    GOCACHE=\"\${GOCACHE}\" \
    GOMODCACHE=\"\${GOMODCACHE}\" \
    PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
      \"${cwsw}/go/current/bin/go\" build -x -ldflags '-s -w -extldflags \"-s -static\"' -o build/
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/share\"
  install -m 0755 build/${rname} \"${ridir}/bin/${rname}\"
  ( cd share/ ; tar -cf - . ) | ( cd \"${ridir}/share\" ; tar -xf - )
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
