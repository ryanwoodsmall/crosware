rname="wolfssl"
rver="4.4.0"
rdir="${rname}-${rver}-stable"
rfile="v${rver}-stable.tar.gz"
rurl="https://github.com/wolfSSL/${rname}/archive/${rfile}"
rsha256="7f854804c8ae0ca49cc77809e38e9a3b5a8c91ba7855ea928e6d6651b0d35f18"
rreqs="make perl m4 autoconf automake libtool cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  touch wolfssl/wolfcrypt/fips.h
  touch cyassl/ctaocrypt/fips.h
  env PATH=${cwsw}/autoconf/current/bin:${cwsw}/automake/current/bin:${cwsw}/libtool/current/bin:\${PATH} libtoolize
  env PATH=${cwsw}/autoconf/current/bin:${cwsw}/automake/current/bin:${cwsw}/libtool/current/bin:\${PATH} autoreconf -fiv -I${cwsw}/libtool/current/share/aclocal
  sed -i '/^#!/s#/bin/sh#/usr/bin/env bash#g' configure
  bash ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --enable-all \
    --enable-singlethreaded \
    --enable-distro \
    --disable-fips \
    --enable-tlsv10 \
    --enable-jobserver=no \
    --disable-examples \
      CFLAGS=\"\${CFLAGS}\" \
      LDFLAGS=-static \
      CPPFLAGS=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  test -e \"${ridir}/include/wolfssl/options.h\" || cp wolfssl/options.h \"${ridir}/include/wolfssl/\"
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
