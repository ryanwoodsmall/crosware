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
rver="0.5.3-git20220429"
rdir="${rname}-${rver}"
rfile="v${rver//-/+}.tar.gz"
rurl="https://github.com/tats/${rname}/archive/${rfile}"
rsha256="6d76fcccb7c94658f2753f0777f69283d5cb447004a0d0d3087c1d873edc0af3"
rreqs="make libatomicops gc gettexttiny ncurses openssl perl pkgconfig zlib cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
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
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
