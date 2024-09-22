#
# XXX - examples seem to work with username/password, but tinycurl does not?
#
rname="wolfssh"
rver="1.4.18"
rdir="${rname}-${rver}-stable"
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="cdede2f52b7b079df0023e7a70de9a1867e3ef4a9d14a0d10de68bcac97dd9c0"
rreqs="make wolfssl configgit slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --enable-all \
    --with-wolfssl=\"${cwsw}/wolfssl/current\" \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}= \
      LDFLAGS='-static -s'
  popd &>/dev/null
}
"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG '/define serverKeyRsaPemFile/s,^.*,#define serverKeyRsaPemFile \"${rtdir}/current/keys/server-key-rsa.pem\",g' wolfssh/test.h
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool}
  for p in client echoserver portfwd ; do
    install -m 0755 \"./examples/\${p}/.libs/\${p}\" \"\$(cwidir_${rname})/bin/${rname}-\${p}\"
  done
  unset p
  ln -sf \"${rname}-client\" \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rname}-client\" \"\$(cwidir_${rname})/bin/${rname}-ssh\"
  install -m 0755 ./examples/scpclient/.libs/wolfscp \"\$(cwidir_${rname})/bin/wolfscp\"
  ln -sf wolfscp \"\$(cwidir_${rname})/bin/${rname}-scp\"
  install -m 0755 ./examples/sftpclient/.libs/wolfsftp \"\$(cwidir_${rname})/bin/wolfsftp\"
  ln -sf wolfsftp \"\$(cwidir_${rname})/bin/${rname}-sftp\"
  ln -sf wolfsshd \"\$(cwidir_${rname})/bin/${rname}-sshd\"
  rm -rf \"\$(cwidir_${rname})/keys\"
  mkdir -p \"\$(cwidir_${rname})/keys\"
  ( cd keys ; tar -cf - .) | ( cd \"\$(cwidir_${rname})/keys/\" ; tar -xf - )
  sed -i \"s,\$(cwidir_${rname}),${rtdir}/current,g\" \"\$(cwidir_${rname})/bin/${rname}-config\"
  sed -i 's,-lwolfssl,-L${cwsw}/wolfssl/current/lib -lwolfssl,g' \"\$(cwidir_${rname})/bin/${rname}-config\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
