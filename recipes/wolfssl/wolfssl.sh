rname="wolfssl"
rver="4.1.0"
rdir="${rname}-${rver}-stable"
rfile="v${rver}-stable.tar.gz"
rurl="https://github.com/wolfSSL/${rname}/archive/${rfile}"
rsha256="f0d630c3ddfeb692b8ae38cc739f47d5e9f0fb708662aa241ede0c42a5eb3dd8"
rreqs="make perl m4 autoconf automake libtool zlib cacertificates"

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
    --with-libz=\"${cwsw}/zlib/current/\" \
    --enable-jobserver=no \
    --disable-examples \
    --disable-openssh \
    --disable-opensslcoexist \
    --disable-opensslextra \
      CFLAGS=\"\${CFLAGS}\" \
      LDFLAGS=\"-static -L${cwsw}/zlib/current/lib\" \
      CPPFLAGS=\"-I${cwsw}/zlib/current/include\"
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
