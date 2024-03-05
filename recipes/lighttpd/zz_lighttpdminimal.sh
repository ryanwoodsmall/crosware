rname="lighttpdminimal"
rver="$(cwver_lighttpd)"
rdir="$(cwdir_lighttpd)"
rfile="$(cwfile_lighttpd)"
rdlfile="$(cwdlfile_lighttpd)"
rurl="$(cwurl_lighttpd)"
rsha256=""
rreqs="make pkgconfig libbsd zlib pcre2 mbedtls lua"

. "${cwrecipe}/common.sh"

for f in fetch clean extract make patch ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_${rname%minimal}
  }
  "
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/pcre2/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      --enable-ipv6 \
      --with-{zlib,pcre2,mbedtls,lua} \
      --without-{webdav-{locks,props},bzip2,attr,libxml,sqlite,brotli,zstd,xxhash} \
        CC=\"\${CC} -g0 -Os -Wl,-s \$(pkg-config --cflags --libs libbsd-overlay zlib libpcre2-posix)\" \
        CXX=\"\${CXX} -g0 -Os -Wl,-s \$(pkg-config --cflags --libs libbsd-overlay zlib libpcre2-posix)\" \
        CFLAGS=\"-fPIC -Wl,-rpath,${rtdir}/current/lib -g0 -Os -Wl,-s\" \
        CXXFLAGS=\"-fPIC -Wl,-rpath,${rtdir}/current/lib -g0 -Os -Wl,-s\" \
        CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -s\" \
        LIBS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib -l{z,mbedx509,mbedtls,mbedcrypto})\" \
        LUA_CFLAGS=\"-I${cwsw}/lua/current/include\" \
        LUA_LIBS=\"-L${cwsw}/lua/current/libs -llua\" \
        PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  rm -f \$(cwidir_${rname})/lib/*.la
  ln -sf lighttpd \"\$(cwidir_${rname})/sbin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/lighttpd/current/sbin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"
