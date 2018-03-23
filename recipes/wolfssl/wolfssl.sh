rname="wolfssl"
rver="3.14.0"
rdir="${rname}-${rver}-stable"
rfile="v${rver}-stable.tar.gz"
rurl="https://github.com/wolfSSL/${rname}/archive/${rfile}"
rsha256="4ab543c869a65a77dc5d0bc934b9d4852aa3d5834bd2f707a74a936602bd3687"
rreqs="make perl m4 autoconf automake libtool zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  touch wolfssl/wolfcrypt/fips.h
  touch cyassl/ctaocrypt/fips.h
  env PATH=${cwsw}/autoconf/current/bin:${cwsw}/automake/current/bin:${cwsw}/libtool/current/bin:\${PATH} libtoolize
  env PATH=${cwsw}/autoconf/current/bin:${cwsw}/automake/current/bin:${cwsw}/libtool/current/bin:\${PATH} autoreconf -fiv -I${cwsw}/libtool/current/share/aclocal
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --enable-all \
    --disable-fips \
    --enable-tlsv10 \
    --with-libz=\"${cwsw}/zlib/current/\" \
    --enable-jobserver=no \
    --disable-openssh \
    --disable-opensslcoexist \
    --disable-opensslextra \
      CFLAGS='-Wl,-static' \
      LDFLAGS=\"-static -L${cwsw}/zlib/current/lib\" \
      CPPFLAGS=\"-I${cwsw}/zlib/current/include\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
