#
# XXX - our perl needs to be at front of path for config/make
# XXX - other "openssl version -a" stuff?
# XXX - 1.1.1j disables threads/pic with -static in LDFLAGS. WHY? COME ON
#

rname="openssl"
rver="1.1.1j"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.openssl.org/source/${rfile}"
rsha256="aaf2fcb575cdf6491b98ab4829abf78a3dec8402b8b81efc8f23c00d443981bf"
rreqs="make perl zlib cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG '/if.*eq.*-static/s/-static/-blahblahblah/g' Configure
  env PATH=\"${cwsw}/perl/current/bin:\${PATH}\" \
    ./config --prefix=${ridir} --openssldir=${cwetc}/ssl no-asm no-shared zlib no-zlib-dynamic \${CFLAGS} \${LDFLAGS} \${CPPFLAGS} -fPIC -DOPENSSL_PIC -DOPENSSL_THREADS
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make install_sw
  sed -i '/^Libs:/s/$/ -lz/g' ${ridir}/lib/pkgconfig/*.pc
  sed -i '/^Requires/s/\$/ zlib/g' ${ridir}/lib/pkgconfig/*.pc
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
