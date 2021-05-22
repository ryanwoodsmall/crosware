rname="haproxylibressl"
rver="$(cwver_haproxy)"
rdir="$(cwdir_haproxy)"
rfile="$(cwfile_haproxy)"
rdlfile="$(cwdlfile_haproxy)"
rurl="$(cwurl_haproxy)"
rsha256=""
rprof="${cwetcprofd}/zz_${rname}.sh"
rreqs="make libressl pcre2 zlib lua"

. "${cwrecipe}/common.sh"

for f in fetch clean configure ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_${rname%libressl}
  }
  "
done
unset f

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} \
    V=1 \
    PREFIX=\"${ridir}\" \
    TARGET=linux-musl \
    USE_{THREAD,PTHREAD_PSHARED,OPENSSL,{,STATIC_}PCRE2,ZLIB,{,LINUX_}TPROXY,CRYPT_H,GETADDRINFO,LUA}=1 \
    SSL_INC=\"${cwsw}/libressl/current/include\" \
    SSL_LIB=\"${cwsw}/libressl/current/include\" \
    ZLIB_INC=\"${cwsw}/zlib/current/include\" \
    ZLIB_LIB=\"${cwsw}/zlib/current/lib\" \
    PCRE2_INC=\"${cwsw}/pcre2/current/include\" \
    PCRE2_LIB=\"${cwsw}/pcre2/current/lib\" \
    LUA_INC=\"${cwsw}/lua/current/include\" \
    LUA_LIB=\"${cwsw}/lua/current/lib\" \
    CC=\"\${CC}\" \
    LDFLAGS=\"-L${cwsw}/libressl/current/lib -static\" \
    CPPFLAGS=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} install \
    V=1 \
    PREFIX=\"${ridir}\" \
    TARGET=linux-musl \
    USE_{THREAD,PTHREAD_PSHARED,OPENSSL,{,STATIC_}PCRE2,ZLIB,{,LINUX_}TPROXY,CRYPT_H,GETADDRINFO,LUA}=1 \
    SSL_INC=\"${cwsw}/libressl/current/include\" \
    SSL_LIB=\"${cwsw}/libressl/current/include\" \
    ZLIB_INC=\"${cwsw}/zlib/current/include\" \
    ZLIB_LIB=\"${cwsw}/zlib/current/lib\" \
    PCRE2_INC=\"${cwsw}/pcre2/current/include\" \
    PCRE2_LIB=\"${cwsw}/pcre2/current/lib\" \
    LUA_INC=\"${cwsw}/lua/current/include\" \
    LUA_LIB=\"${cwsw}/lua/current/lib\" \
    CC=\"\${CC}\" \
    LDFLAGS=\"-L${cwsw}/libressl/current/lib -static\" \
    CPPFLAGS=
  \$(\${CC} -dumpmachine)-strip --strip-all \"${ridir}/sbin/${rname%libressl}\"
  ln -sf \"${rtdir}/current/sbin/${rname%libressl}\" \"${ridir}/sbin/${rname%libressl}${rname#haproxy}\"
  ln -sf \"${rtdir}/current/sbin/${rname%libressl}\" \"${ridir}/sbin/${rname%libressl}-${rname#haproxy}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
