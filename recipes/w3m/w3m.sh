#
# XXX - ugly disabling of garbage collection below
# XXX - build against shared gc?
#   LIBS='-lssl -lcrypto -lz -latomic_ops -lgc' \
#   CFLAGS=\"\${CFLAGS//-Wl,-static/} -Wl,-rpath=${cwsw}/gc/current/lib\" \
#   CXXFLAGS=\"\${CXXFLAGS//-Wl,-static/} -Wl,-rpath=${cwsw}/gc/current/lib\" \
#   LDFLAGS=\"\${LDFLAGS//-static/}\"
# XXX - libressl variant
# XXX - netbsdcurses?
#

rname="w3m"
rver="0.5.3-git20230121"
rdir="${rname}-${rver}"
rfile="v${rver//-/+}.tar.gz"
rurl="https://github.com/tats/${rname}/archive/${rfile}"
rsha256="fdc7d55d3c0104db26aa9759db34f37e5eee03f44c868796e3bbfb8935c96e39"
rreqs="make libatomicops gc gettexttiny ncurses openssl perl pkgconfig zlib cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG '/^for lib in .*nsl/ s/ in / in dne #/g' configure
  env PATH=${cwsw}/perl/current/bin:\${PATH} ./configure ${cwconfigureprefix} \
    --disable-mouse \
    --disable-sslverify \
    --enable-image=no \
    --with-gc=${cwsw}/gc/current \
    --with-ssl=${cwsw}/openssl/current \
    --with-termlib=ncurses \
      LIBS='-lssl -lcrypto -lz'
  sed -i.ORIG 's/GC_INIT/setenv(\"GC_DONT_GC\",\"1\",\"1\");GC_INIT/g' main.c
  #sed -i.ORIG 's/GC_INIT/setenv(\"GC_INITIAL_HEAP_SIZE\",\"256M\",\"1\");GC_INIT/g' main.c
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
