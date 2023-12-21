#
# XXX - BROKEN WITH WOLFSSL 5.6.6 - heap changes here/there (heapmath?) or something else is breaking...
# XXX - examples seem to work with username/password, but tinycurl does not?
# XXX - DYNATYPE_AGENT_ID? DYNTYPE_AGENT_ID? ssh->heap? ssh->ctx->heap?
#   grep -rl DYNATYPE_AGENT_ID . | xargs sed -i.ORIG s,DYNATYPE_AGENT_ID,DYNTYPE_AGENT_ID,g 2>/dev/null || true
#   grep -rl 'ssh->heap' . | xargs sed -i.ORIG 's,ssh->heap,ssh->ctx->heap,g' 2>/dev/null || true
#

rname="wolfssh"
rver="1.4.14"
rdir="${rname}-${rver}-stable"
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="0b0094cfdbbe306530cedfd1ea7b40f1c6372b2840a9373cb21faee1e85dc513"
rreqs="make wolfssl configgit slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
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
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG '/define serverKeyRsaPemFile/s,^.*,#define serverKeyRsaPemFile \"${rtdir}/current/keys/server-key-rsa.pem\",g' wolfssh/test.h
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  for p in client echoserver portfwd server ; do
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
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
