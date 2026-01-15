#
# to create and exchange certs on a single node to test:
#   for t in client server ; do
#     ${cwsw}/bearssl/current/bin/brssl skey -gen rsa:2048 -rawpem ${cwtop}/tmp/ghostunnel-${t}.key
#     ${cwsw}/x509cert/current/bin/x509cert -a $(hostname) -d $((100*366*24*60*60)) ${cwtop}/tmp/ghostunnel-${t}.key CN=$(hostname) | tee ${cwtop}/tmp/ghostunnel-${t}.crt
#     cat ${cwtop}/tmp/ghostunnel-${t}.crt >> ${cwtop}/tmp/ghostunnel-cacert.pem
#   done
#
# server:
#   ${cwsw}/ghostunnel/current/bin/ghostunnel \
#     server \
#       --listen=0.0.0.0:12343 \
#       --target=localhost:12380 \
#       --cert=${cwtop}/tmp/ghostunnel-server.crt \
#       --key=${cwtop}/tmp/ghostunnel-server.key \
#       --cacert=${cwtop}/tmp/ghostunnel-cacert.pem \
#       --allow-cn=$(hostname)
#
# client:
#   ${cwsw}/ghostunnel/current/bin/ghostunnel \
#     client \
#       --unsafe-listen \
#       --listen=localhost:12381 \
#       --target=$(hostname):12343 \
#       --cert=${cwtop}/tmp/ghostunnel-client.crt \
#       --key=${cwtop}/tmp/ghostunnel-client.key \
#       --cacert=${cwtop}/tmp/ghostunnel-cacert.pem \
#       --verify-cn=$(hostname)
#
rname="ghostunnel"
rver="1.9.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/${rname}/${rname}/archive/refs/tags/${rfile}"
rsha256="0cc3b2ac8b30aa6d6c2c3df9289436b985c21aed6f986b025c7a4057666bd47c"
rreqs="go cacertificates bootstrapmake"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  test -e \"\$(cwbdir_${rname})\" && chmod -R u+rw \"\$(cwbdir_${rname})/\" || true
  rm -rf \"\$(cwbdir_${rname})\"
  popd &>/dev/null
}
"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG \"s,^VERSION.*,VERSION=\$(cwver_${rname}),g\" Makefile
  sed -i '/-ldflags/s,-X,-s -w -X,g' Makefile
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
      VERSION=\"\$(cwver_${rname})\" \
      CGO_ENABLED=0 \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
        make ${rname}{,.man}
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  cwmkdir \"\$(cwidir_${rname})/share/man/man1\"
  install -m 0755 ${rname} \"\$(cwidir_${rname})/bin/${rname}\"
  install -m 0644 ${rname}.man \"\$(cwidir_${rname})/share/man/man1/${rname}.1\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
