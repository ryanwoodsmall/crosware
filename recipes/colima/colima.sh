rname="colima"
rver="0.10.3"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/abiosoft/colima/archive/refs/tags/${rfile}"
rsha256="7aa687a4905c42de18d397ef45e9fc37ace08641c0ac2e4bcc9d9a67a5be97fe"
rreqs="go bootstrapmake lima"

if ! command -v openssl &>/dev/null ; then
  rreqs+=" libressl"
fi

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
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cat Makefile > Makefile.ORIG
  sed -i \"/^INSTALL_DIR/s,/usr/local.*, \$(cwidir_${rname}),g\" Makefile
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
      CGO_LDFLAGS='-Os -g0 -static -s' \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
        make \
          INSTALL_DIR=\"\$(cwidir_${rname})\" \
          VERSION=\"\$(cwver_${rname})\"
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \$(cwidir_${rname})
  rm -f \$(cwidir_${rname})/${rname}
  (
    : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
    : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
    env \
      CGO_ENABLED=0 \
      CGO_LDFLAGS='-Os -g0 -static -s' \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
        make install \
          INSTALL_DIR=\"\$(cwidir_${rname})\" \
          VERSION=\"\$(cwver_${rname})\"
    chmod -R u+rw . || true
  )
  cwmkdir \$(cwidir_${rname})/bin
  rm -f \$(cwidir_${rname})/bin/${rname}
  mv \$(cwidir_${rname})/${rname} \$(cwidir_${rname})/bin/${rname}
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
