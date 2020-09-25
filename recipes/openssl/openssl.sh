#
# XXX - our perl needs to be at front of path for config/make
# XXX - -DOPENSSL_PIC ???
# XXX - other "openssl version -a" stuff?
#

rname="openssl"
rver="1.1.1h"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.openssl.org/source/${rfile}"
rsha256="5c9ca8774bd7b03e5784f26ae9e9e6d749c9da2438545077e6b3d755a06595d9"
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
