#
# XXX - wget2: wolfssl, bison, flex, xz, ...
# XXX - c-ares support
# XXX - libpsl support
# XXX - libressl variant
# XXX - gnutls variant
# XXX - disabled metalink+expat 20220226
# XXX - metalink has gpgme support, probably not worth supporting for now
#

rname="wget"
rver="1.21.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.lz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="dbd2fb5e47149d4752d0eaa0dac68cc49cf20d46df4f8e326ffc8f18b2af4ea5"
rreqs="make lunzip openssl zlib pcre2 gettexttiny pkgconfig sed cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --disable-nls \
    --with-ssl=openssl \
    --with-openssl=yes \
    --with-zlib \
    --disable-pcre \
    --enable-pcre2 \
    --with-included-libunistring \
    --with-included-regex \
    --without-metalink
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  #echo 'alias ${rname}=\"${rtdir}/current/bin/${rname} --no-check-certificate\"' >> \"${rprof}\"
}
"
