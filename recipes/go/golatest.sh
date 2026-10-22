#
# XXX - check and notify if latest is out of date!!!
# XXX - may need to manually clean up...
#
rname="golatest"
rver="1.27.2"
rdir="go"
rfile="go${rver}.src.tar.gz"
rurl="https://go.dev/dl/${rfile}"
rsha256="03495da2ba64894d40f5c4992e49454fa78b50690604ff92b6afff5081b76e62"
rgobootstrap="127"
rreqs="bashtiny bootstrapmake busybox toybox go${rgobootstrap}"
rprof="${cwetcprofd}/zz_${rname}.sh"
ridir="${cwsw}/${rname}/${rdir}-${rver}"

. "${cwrecipe}/common.sh"

cwstubfunc "cwmake_${rname}"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  rm -rf go
  popd &>/dev/null
}
"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  pushd src &>/dev/null
  cat crypto/x509/root_linux.go > crypto/x509/root_linux.go.ORIG
  sed -i 's|\"/etc/ssl/cert.pem\"|\"/etc/ssl/cert.pem\",\"'\"${cwtop}/etc/ssl/cert.pem\"'\"|g' crypto/x509/root_linux.go
  sed -i 's|\"/etc/ssl/certs\"|\"/etc/ssl/certs\",\"'\"${cwtop}/etc/ssl/certs\"'\"|g' crypto/x509/root_linux.go
  popd &>/dev/null
  popd &>/dev/null
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})\"
  tar -cf - . | ( cd \"\$(cwidir_${rname})/\" ; tar -xf - )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwidir_${rname})\" &>/dev/null
  pushd src &>/dev/null
  cwscriptecho \"building go in \${PWD} in a subshell\"
  (
    export PATH=\"\$(echo ${cwsw}/{ccache{4,},statictoolchain,bashtiny,bootstrapmake,busybox,toybox,go${rgobootstrap}}/current/bin | tr ' ' ':')\"
    unset CPPFLAGS
    unset PKG_CONFIG_{LIBDIR,PATH}
    export LDFLAGS=-static
    env \
      CGO_ENABLED=0 \
      GOROOT_BOOTSTRAP=\"${cwsw}/go${rgobootstrap}/current\" \
      GO_LDFLAGS='-extldflags \"-static -s\" -s -w' \
        bash make.bash
  )
  cwscriptecho \"exit code was \${?} - why is it sometimes 1 when it succeeds\"
  popd &>/dev/null
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

unset rgobootstrap

# vim: set ft=bash:
