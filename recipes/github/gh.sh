rname="gh"
rver="2.11.3"
rdir="cli-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/cli/cli/archive/refs/tags/${rfile}"
rsha256="1a4a90b1893dac022c1cfb298ebb52f66a8f93b353eafcf7bbfb43c8c0b46dfa"
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
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  if [ -e \"${rbdir}\" ] ; then
     chmod -R u+rw \"${rbdir}\" || true
  fi
  rm -rf \"${rbdir}\"
  popd >/dev/null 2>&1
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
