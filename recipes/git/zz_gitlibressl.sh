rname="gitlibressl"
rver="$(cwver_git)"
rdir="${rname%libressl}-${rver}"
rfile="${rdir}.tar.xz"
rdlfile="${cwdl}/${rname%libressl}/${rfile}"
rurl="https://www.kernel.org/pub/software/scm/${rname%libressl}}/${rfile}"
rsha256=""
rreqs="make zlib libressl expat pcre2 perl cacertificates nghttp2 curllibressl opensshlibressl"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/${rname%libressl}/${rname%libressl}.sh.common"

eval "
function cwfetch_${rname}() {
  cwfetch_${rname%libressl}
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"${cwsw}/libressl/current/bin:${cwsw}/curllibressl/current/devbin:${cwsw}/perl/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} \
      --with-curl=\"${cwsw}/curllibressl/current\" \
      --with-expat=\"${cwsw}/expat/current\" \
      --with-libpcre2=\"${cwsw}/pcre2/current\" \
      --with-openssl=\"${cwsw}/libressl/current\" \
      --with-perl=\"${cwsw}/perl/current/bin/perl\" \
      --without-iconv \
      --without-python \
      --without-tcltk \
        CC=\"\${CC}\" \
        CXX=\"\${CXX}\" \
        CFLAGS=\"\${CFLAGS}\" \
        CXXFLAGS=\"\${CXXFLAGS}\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{libressl,zlib,nghttp2,expat,pcre2,curllibressl}/current/lib -static)\" \
        CPPFLAGS=\"\$(echo -I${cwsw}/{libressl,zlib,nghttp2,expat,pcre2,curllibressl}/current/include)\" \
        LIBS='-lcurl -lnghttp2 -lssh2 -lssl -lcrypto -lz -lexpat' \
        PKG_CONFIG_LIBDIR= \
        PKG_CONFIG_PATH=
  sed -i.ORIG 's/-lcurl/-lcurl -lnghttp2 -lssh2 -lssl -lcrypto -lz -lexpat/g' Makefile
  grep -ril sys/poll\\.h ${rbdir}/ \
  | grep \\.h\$ \
  | xargs sed -i.ORIG 's#sys/poll\.h#poll.h#g'
  popd >/dev/null 2>&1
}
"


eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"${cwsw}/curllibressl/current/devbin:\${PATH}\" make -j${cwmakejobs} NO_GETTEXT=1 NO_ICONV=1 NO_MSGFMT_EXTENDED_OPTIONS=1
  popd >/dev/null 2>&1
}
"
