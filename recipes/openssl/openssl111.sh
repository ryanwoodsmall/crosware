#
# XXX - see openssl virtual recipe file recipes/openssl/zz_openssl.sh for notes!
#
rname="openssl111"
rver="1.1.1w"
rdir="${rname%111}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.openssl.org/source/${rfile}"
rsha256="cf3098950cb4d853ad95c0841f1f9c6d3dc102dccfcacd521d93925208b76ac8"
rreqs="make perl cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG '/if.*eq.*-static/s/-static/-blahblahblah/g' Configure
  env \
    PATH=\"${cwsw}/perl/current/bin:\${PATH}\" \
    LDFLAGS=-static \
    CPPFLAGS= \
    PKG_CONFIG_{LIBDIR,PATH}= \
      ./config --prefix=\"\$(cwidir_${rname})\" --openssldir=${cwetc}/ssl no-asm no-shared no-zlib no-zlib-dynamic \${CFLAGS} -static -fPIC -DOPENSSL_PIC -DOPENSSL_THREADS
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install_sw
  sed -i '/^Requires/s/\\.private:/:/g' \$(cwidir_${rname})/lib/pkgconfig/*.pc
  sed -i s,\$(cwidir_${rname}),${rtdir}/current,g \$(cwidir_${rname})/lib/pkgconfig/*.pc
  popd >/dev/null 2>&1
}
"
