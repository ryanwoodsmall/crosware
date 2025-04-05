rname="hub"
rver="2.14.2"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/github/${rname}/archive/refs/tags/${rfile}"
rsha256="e19e0fdfd1c69c401e1c24dd2d4ecf3fd9044aa4bd3f8d6fd942ed1b2b2ad21a"
rreqs="go make groff utillinux mandoc"

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
  pushd \"${cwbuild}\" &>/dev/null
  chmod -R u+rw \"${rbdir}\" || true
  rm -rf \"${rbdir}\"
  popd &>/dev/null
}
"

eval "
function cwpatch_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  sed -i.ORIG 's,/usr/local,${ridir},g' script/install.sh
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  (
    : \${GOCACHE=\"${rbdir}/gocache\"}
    : \${GOMODCACHE=\"${rbdir}/gomodcache\"}
    env \
      PATH=\"${cwsw}/groff/current/bin:${cwsw}/utillinux/current/bin:\${PATH}\" \
      LANG=C \
      CGO_ENABLED=0 \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
        make
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  (
    : \${GOCACHE=\"${rbdir}/gocache\"}
    : \${GOMODCACHE=\"${rbdir}/gomodcache\"}
    sed -i.ORIG s,groff,${cwsw}/groff/current/bin/groff,g Makefile
    sed -i.ORIG s,col,${cwsw}/utillinux/current/bin/col,g Makefile
    env \
      PATH=\"${cwsw}/groff/current/bin:${cwsw}/utillinux/current/bin:\${PATH}\" \
      LANG=C \
      CGO_ENABLED=0 \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
        make install
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'alias hub=\"env MANPATH=${cwsw}/hub/current/share/man ${cwsw}/hub/current/bin/hub\"' >> \"${rprof}\"
}
"
