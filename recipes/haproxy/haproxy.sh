rname="haproxy"
rver="2.2.14"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://www.haproxy.org/download/${rver%.*}/src/${rfile}"
rsha256="6a9b702f04b07786f3e5878de8172a727acfdfdbc1cefe1c7a438df372f2fb61"
rreqs="make openssl pcre2 zlib lua"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG 's,-lpthread,-lpthread -latomic,g' Makefile
  sed -i 's/-Wl,-Bdynamic/-Wl,-static -static/g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} \
    V=1 \
    PREFIX=\"${ridir}\" \
    TARGET=linux-musl \
    USE_{THREAD,PTHREAD_PSHARED,OPENSSL,{,STATIC_}PCRE2,ZLIB,{,LINUX_}TPROXY,CRYPT_H,GETADDRINFO,LUA}=1 \
    SSL_INC=\"${cwsw}/openssl/current/include\" \
    SSL_LIB=\"${cwsw}/openssl/current/include\" \
    ZLIB_INC=\"${cwsw}/zlib/current/include\" \
    ZLIB_LIB=\"${cwsw}/zlib/current/lib\" \
    PCRE2_INC=\"${cwsw}/pcre2/current/include\" \
    PCRE2_LIB=\"${cwsw}/pcre2/current/lib\" \
    LUA_INC=\"${cwsw}/lua/current/include\" \
    LUA_LIB=\"${cwsw}/lua/current/lib\" \
    CC=\"\${CC}\" \
    LDFLAGS=\"\${LDFLAGS}\"
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
    SSL_INC=\"${cwsw}/openssl/current/include\" \
    SSL_LIB=\"${cwsw}/openssl/current/include\" \
    ZLIB_INC=\"${cwsw}/zlib/current/include\" \
    ZLIB_LIB=\"${cwsw}/zlib/current/lib\" \
    PCRE2_INC=\"${cwsw}/pcre2/current/include\" \
    PCRE2_LIB=\"${cwsw}/pcre2/current/lib\" \
    LUA_INC=\"${cwsw}/lua/current/include\" \
    LUA_LIB=\"${cwsw}/lua/current/lib\" \
    CC=\"\${CC}\" \
    LDFLAGS=\"\${LDFLAGS}\"
  \$(\${CC} -dumpmachine)-strip --strip-all \"${ridir}/sbin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
