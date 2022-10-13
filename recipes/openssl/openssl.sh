#
# XXX - our perl needs to be at front of path for config/make
# XXX - other "openssl version -a" stuff?
# XXX - 1.1.1j disables threads/pic with -static in LDFLAGS. WHY? COME ON
# XXX - disable zlib to workaround some conflicts (redis) and pain with forcing libz.a
# XXX - remove `-lz` "fix" - this shouldn't be necessary but will need a full rebuild
# XXX - need openssl11, openssl3, etc.?
#

rname="openssl"
rver="1.1.1r"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.openssl.org/source/${rfile}"
rsha256="e389352ae3d5ae4d38597bf8a54f1dcb6fb3c8b50f4fe58a94bb1bf7f85d82a0"
rreqs="make perl cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG '/if.*eq.*-static/s/-static/-blahblahblah/g' Configure
  env PATH=\"${cwsw}/perl/current/bin:\${PATH}\" \
    ./config --prefix=\"\$(cwidir_${rname})\" --openssldir=${cwetc}/ssl no-asm no-shared no-zlib no-zlib-dynamic \${CFLAGS} \${LDFLAGS} \${CPPFLAGS} -fPIC -DOPENSSL_PIC -DOPENSSL_THREADS
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install_sw
  sed -i '/^Libs:/s/$/ -lz/g' \$(cwidir_${rname})/lib/pkgconfig/*.pc
  sed -i '/^Requires/s/\\.private:/:/g' \$(cwidir_${rname})/lib/pkgconfig/*.pc
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  #echo 'append_cppflags \"-I${rtdir}/current/include/${rname}\"' >> \"${rprof}\"
}
"
