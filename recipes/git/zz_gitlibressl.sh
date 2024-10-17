rname="gitlibressl"
rver="$(cwver_git)"
rdir="$(cwdir_git)"
rfile="$(cwfile_git)"
rdlfile="$(cwdlfile_git)"
rurl="$(cwurl_git)"
rsha256="$(cwsha256_git)"
rreqs="make zlib libressl expat pcre2 perl cacertificates nghttp2 curllibressl libssh2libressl mandoc"

. "${cwrecipe}/${rname%libressl}/${rname%libressl}.sh.common"

for f in fetch patch ; do
  eval "
  function cwfetch_${rname}() {
    cwfetch_${rname%libressl}
  }
  "
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
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
        LDFLAGS=\"\$(echo -L${cwsw}/{libressl,zlib,nghttp2,expat,pcre2,curllibressl,libssh2libressl}/current/lib -static)\" \
        CPPFLAGS=\"\$(echo -I${cwsw}/{libressl,zlib,nghttp2,expat,pcre2,curllibressl,libssh2libressl}/current/include)\" \
        PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
        LIBS='-lcurl -latomic -lnghttp2 -lssh2 -lssl -lcrypto -lz -lexpat'
  sed -i.ORIG 's/-lcurl/-lcurl -latomic -lnghttp2 -lssh2 -lssl -lcrypto -lz -lexpat/g' Makefile
  : sed -i '/:.* build-unit-tests/s,build-unit-tests,,g' Makefile
  : sed -i '/:.* unit-tests/s,unit-tests,,g' Makefile
  grep -ril sys/poll\\.h \$(cwbdir_${rname})/ \
  | grep \\.h\$ \
  | xargs sed -i.ORIG 's#sys/poll\.h#poll.h#g'
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=\"${cwsw}/curllibressl/current/devbin:\${PATH}\" make -j${cwmakejobs} NO_GETTEXT=1 NO_ICONV=1 NO_MSGFMT_EXTENDED_OPTIONS=1 \
    CC=\"\${CC}\" \
    CXX=\"\${CXX}\" \
    CFLAGS=\"\${CFLAGS}\" \
    CXXFLAGS=\"\${CXXFLAGS}\" \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd &>/dev/null
}
"
