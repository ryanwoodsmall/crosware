rname="gitlibressl"
rver="$(cwver_git)"
rdir="${rname%libressl}-${rver}"
rfile="${rdir}.tar.xz"
rdlfile="${cwdl}/${rname%libressl}/${rfile}"
rurl="https://www.kernel.org/pub/software/scm/${rname%libressl}}/${rfile}"
rsha256=""
rreqs="make zlib libressl expat pcre2 perl cacertificates nghttp2"

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
  env PATH=\"${cwsw}/libressl/current/bin:${cwsw}/perl/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} \
      --with-curl \
      --with-expat \
      --with-libpcre2 \
      --with-openssl=\"${cwsw}/libressl/current\" \
      --with-perl=\"${cwsw}/perl/current/bin/perl\" \
      --without-iconv \
      --without-python \
      --without-tcltk \
        CC=\"\${CC}\" \
        CXX=\"\${CXX}\" \
        CFLAGS=\"\${CFLAGS}\" \
        CXXFLAGS=\"\${CXXFLAGS}\" \
        LDFLAGS=\"-L${cwsw}/libressl/current/lib -L${cwsw}/zlib/current/lib -L${cwsw}/nghttp2/current/lib -L${cwsw}/expat/current/lib -L${cwsw}/pcre2/current/lib -static\" \
        CPPFLAGS=\"-I${cwsw}/libressl/current/include -I${cwsw}/zlib/current/include -I${cwsw}/nghttp2/current/include -I${cwsw}/expat/current/include -I${cwsw}/pcre2/current/include\" \
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
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} install NO_GETTEXT=1 NO_ICONV=1 NO_MSGFMT_EXTENDED_OPTIONS=1
  ln -sf \"${rtdir}/current/bin/${rname%libressl}\" \"${ridir}/bin/${rname}\"
  cwmkdir \"${ridir}/etc\"
  cwextract \"${rdlfile//${rname%libressl}-${rver}/${rname%libressl}-manpages-${rver}}\" \"${ridir}/share/man\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir%libressl}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
