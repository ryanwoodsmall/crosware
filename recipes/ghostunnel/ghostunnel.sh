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
rver="1.8.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/${rname}/${rname}/archive/refs/tags/${rfile}"
rsha256="f6f228d305a508b63a94961f68ec0222f3b08b4a84183b9e5893b24ff208929a"
rreqs="go cacertificates"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  test -e \"\$(cwbdir_${rname})\" && chmod -R u+rw \"\$(cwbdir_${rname})/\" || true
  rm -rf \"\$(cwbdir_${rname})\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  (
    : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
    : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
    env \
      CGO_ENABLED=0 \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
        go build -ldflags \"-s -w -extldflags '-s -static' -X main.version=\$(cwver_${rname})\" -o ${rname} .
    ./${rname} --help-custom-man > ${rname}.1
    chmod -R u+rw . || true
  )
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  cwmkdir \"\$(cwidir_${rname})/share/man/man1\"
  install -m 0755 ${rname} \"\$(cwidir_${rname})/bin/${rname}\"
  install -m 0644 ${rname}.1 \"\$(cwidir_${rname})/share/man/man1/${rname}.1\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
