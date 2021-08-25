#
# XXX - our perl needs to be at front of path for config/make
# XXX - other "openssl version -a" stuff?
# XXX - 1.1.1j disables threads/pic with -static in LDFLAGS. WHY? COME ON
# XXX - disable zlib to workaround some conflicts (redis) and pain with forcing libz.a
#

rname="openssl"
rver="1.1.1l"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.openssl.org/source/${rfile}"
rsha256="0b7a3e5e59c34827fe0c3a74b7ec8baef302b98fa80088d7f9153aa16fa76bd1"
rreqs="make perl cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG '/if.*eq.*-static/s/-static/-blahblahblah/g' Configure
  env PATH=\"${cwsw}/perl/current/bin:\${PATH}\" \
    ./config --prefix=${ridir} --openssldir=${cwetc}/ssl no-asm no-shared no-zlib no-zlib-dynamic \${CFLAGS} \${LDFLAGS} \${CPPFLAGS} -fPIC -DOPENSSL_PIC -DOPENSSL_THREADS
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make install_sw
  sed -i '/^Libs:/s/$/ -lz/g' ${ridir}/lib/pkgconfig/*.pc
  sed -i '/^Requires/s/\\.private:/:/g' ${ridir}/lib/pkgconfig/*.pc
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
