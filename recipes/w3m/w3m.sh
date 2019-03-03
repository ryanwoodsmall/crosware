#
# XXX - ugly disabling of garbage collection below
#

rname="w3m"
rver="0.5.3-git20190105"
rdir="${rname}-${rver}"
rfile="v${rver//-/+}.tar.gz"
rurl="https://github.com/tats/${rname}/archive/${rfile}"
rsha256="0467bb5429b75749205a3f57b9f5e8abba49929272aeab6fce94ff17953f0784"
rreqs="make libatomicops gc gettexttiny ncurses openssl perl pkgconfig zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
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
