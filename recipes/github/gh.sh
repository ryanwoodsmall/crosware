rname="gh"
rver="2.54.0"
rdir="cli-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/cli/cli/archive/refs/tags/${rfile}"
rsha256="eedac958431876cebe243925dc354b0c21915d1bc84c5678a8073f0ec91d6a4c"
rreqs="go bootstrapmake"

if ! command -v git &>/dev/null ; then
  rreqs="${rreqs} git"
fi

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  if [ -e \"\$(cwbdir_${rname})\" ] ; then
     chmod -R u+rw \"\$(cwbdir_${rname})\" || true
  fi
  rm -rf \"\$(cwbdir_${rname})\"
  popd &>/dev/null
}
"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG \"s,/usr/local,\$(cwidir_${rname}),g\" Makefile
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
    : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
    env \
      CGO_ENABLED=0 \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
      GH_VERSION=\"\$(cwver_${rname})\" \
      GO_LDFLAGS='-s -w' \
        make
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
    : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
    env \
      CGO_ENABLED=0 \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
        make install prefix=\"\$(cwidir_${rname})\"
    chmod -R u+rw .
  )
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
