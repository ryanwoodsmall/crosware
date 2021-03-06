#
# XXX - wget2: wolfssl, bison, flex, xz, ...
#

rname="wget"
rver="1.21.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.lz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="db9bbe5347e6faa06fc78805eeb808b268979455ead9003a608569c9d4fc90ad"
rreqs="make lunzip openssl zlib pcre2 gettexttiny pkgconfig sed expat libmetalink cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --disable-nls \
    --with-ssl=openssl \
    --with-metalink \
    --with-openssl=yes \
    --with-zlib \
    --disable-pcre \
    --enable-pcre2 \
    --with-included-libunistring \
    --with-included-regex \
      LIBS='-lexpat'
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  #echo 'alias ${rname}=\"${rtdir}/current/bin/${rname} --no-check-certificate\"' >> \"${rprof}\"
}
"
