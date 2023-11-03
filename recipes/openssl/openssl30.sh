rname="openssl30"
rver="3.0.12"
rdir="${rname%30}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.openssl.org/source/${rfile}"
rsha256="f93c9e8edde5e9166119de31755fc87b4aa34863662f67ddfcba14d0b6b69b61"
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
  sed -i.ORIG s,LIBDIR=lib64,LIBDIR=lib,g Makefile || true
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
