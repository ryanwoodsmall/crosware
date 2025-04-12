rname="openssl35"
rver="3.5.0"
rdir="${rname%35}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/openssl/openssl/releases/download/openssl-${rver}/${rfile}"
rsha256="344d0a79f1a9b08029b0744e2cc401a43f9c90acd1044d09a530b4885a8e9fc0"
rreqs="make perl cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG '/if.*eq.*-static/s/-static/-blahblahblah/g' Configure
  env \
    PATH=\"${cwsw}/perl/current/bin:\${PATH}\" \
    LDFLAGS=-static \
    CPPFLAGS= \
    PKG_CONFIG_{LIBDIR,PATH}= \
      ./config --prefix=\"\$(cwidir_${rname})\" --openssldir=${cwetc}/ssl no-asm no-shared no-zlib no-zlib-dynamic \${CFLAGS} -static -fPIC -DOPENSSL_PIC -DOPENSSL_THREADS
  sed -i.ORIG s,LIBDIR=lib64,LIBDIR=lib,g Makefile || true
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install_sw
  sed -i '/^Requires/s/\\.private:/:/g' \$(cwidir_${rname})/lib/pkgconfig/*.pc
  sed -i s,\$(cwidir_${rname}),${rtdir}/current,g \$(cwidir_${rname})/lib/pkgconfig/*.pc
  popd &>/dev/null
}
"
