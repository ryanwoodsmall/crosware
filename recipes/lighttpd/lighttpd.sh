rname="lighttpd"
rver="1.4.59"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://download.lighttpd.net/${rname}/releases-${rver%.*}.x/${rfile}"
rsha256="fb953db273daef08edb6e202556cae8a3d07eed6081c96bd9903db957d1084d5"
rreqs="make zlib bzip2 pcre mbedtls pkgconfig libbsd"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --enable-ipv6 \
    --with-{pcre,zlib,mbedtls,bzip2} \
      CC=\"\${CC} \$(pkg-config --cflags --libs libbsd)\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{bzip2,zlib,pcre,mbedtls}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{bzip2,zlib,pcre,mbedtls}/current/lib)\" \
      CFLAGS=-fPIC \
      CXXFLAGS=-fPIC
  grep -ril 'sys/queue\\.h' . \
  | xargs sed -i.ORIG 's,sys/queue,bsd/sys/queue,g'
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  rm -f ${ridir}/lib/*.la
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
