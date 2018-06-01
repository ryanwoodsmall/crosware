#
# XXX - ugly disabling of garbage collection below
#

rname="w3m"
rver="0.5.3-git20180125"
rdir="${rname}-${rver}"
rfile="v${rver//-/+}.tar.gz"
rurl="https://github.com/tats/${rname}/archive/${rfile}"
rsha256="c75068ef06963c9e3fd387e8695a203c6edda2f467b5f2f754835afb75eb36f3"
rreqs="make gc gettexttiny ncurses openssl perl pkgconfig zlib"

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
