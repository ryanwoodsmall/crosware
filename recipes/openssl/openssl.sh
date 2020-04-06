#
# XXX - our perl needs to be at front of path for config/make
# XXX - -DOPENSSL_PIC ???
# XXX - other "openssl version -a" stuff?
#

rname="openssl"
rver="1.1.1f"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.openssl.org/source/${rfile}"
rsha256="186c6bfe6ecfba7a5b48c47f8a1673d0f3b0e5ba2e25602dd23b629975da3f35"
rreqs="make perl zlib cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./config --prefix=${ridir} --openssldir=${cwetc}/ssl no-asm no-shared zlib no-zlib-dynamic \${CFLAGS} \${LDFLAGS} \${CPPFLAGS} -fPIC
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
