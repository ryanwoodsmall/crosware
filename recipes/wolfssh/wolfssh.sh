#
# XXX - examples seem to work with username/password, but tinycurl does not?
#

rname="wolfssh"
rver="1.4.8"
rdir="${rname}-${rver}-stable"
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="87e0371864c2007954119fb3e5fe24e0fc3b17935ad3deb827a0e2fd0d9cea2f"
rreqs="make wolfssl configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --enable-all \
    --with-wolfssl=\"${cwsw}/wolfssl/current\" \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}= \
      LDFLAGS='-static -s'
  popd >/dev/null 2>&1
}
"

eval "
function cwpatch_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG '/define serverKeyRsaPemFile/s,^.*,#define serverKeyRsaPemFile \"${rtdir}/current/keys/server-key-rsa.pem\",g' wolfssh/test.h
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  for p in client echoserver portfwd server ; do
    install -m 0755 \"./examples/\${p}/\${p}\" \"${ridir}/bin/${rname}-\${p}\"
  done
  unset p
  ln -sf \"${rname}-client\" \"${ridir}/bin/${rname}\"
  ln -sf \"${rname}-client\" \"${ridir}/bin/${rname}-ssh\"
  install -m 0755 ./examples/scpclient/wolfscp \"${ridir}/bin/wolfscp\"
  ln -sf wolfscp \"${ridir}/bin/${rname}-scp\"
  install -m 0755 ./examples/sftpclient/wolfsftp \"${ridir}/bin/wolfsftp\"
  ln -sf wolfsftp \"${ridir}/bin/${rname}-sftp\"
  rm -rf \"${ridir}/keys\"
  mkdir -p \"${ridir}/keys\"
  ( cd keys ; tar -cf - .) | ( cd \"${ridir}/keys/\" ; tar -xf - )
  sed -i 's,${ridir},${rtdir}/current,g' \"${ridir}/bin/${rname}-config\"
  sed -i 's,-lwolfssl,-L${cwsw}/wolfssl/current/lib -lwolfssl,g' \"${ridir}/bin/${rname}-config\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
