rname="gh"
rver="2.5.0"
rdir="cli-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/cli/cli/archive/refs/tags/${rfile}"
rsha256="4e9d1cbcdd2346cab5b7fc176cd57c07ed3628a0241fad8a48fe4df6a354b120"
rreqs="go bootstrapmake"

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
function cwpatch_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG 's,/usr/local,${ridir},g' Makefile
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
      make
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  : \${GOCACHE=\"${rbdir}/gocache\"}
  : \${GOMODCACHE=\"${rbdir}/gomodcache\"}
  env \
    CGO_ENABLED=0 \
    GOCACHE=\"\${GOCACHE}\" \
    GOMODCACHE=\"\${GOMODCACHE}\" \
    PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
      make install prefix=\"${ridir}\"
  chmod -R u+rw .
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
