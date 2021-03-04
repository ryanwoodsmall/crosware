rname="zstd"
rver="1.4.9"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/facebook/${rname}/releases/download/v${rver}/${rfile}"
rsha256="29ac74e19ea28659017361976240c4b5c5c24db3b89338731a6feb97c038d293"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cp lib/Makefile{,.ORIG}
  cp Makefile{,.ORIG}
  sed -i '/^lib/s/libzstd.a libzstd/libzstd.a/g' lib/Makefile
  sed -i '/^install:/s/install-shared//g' lib/Makefile
  sed -i '/^allmost:/s/zlibwrapper//g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make \
    {PREFIX,prefix}=\"${ridir}\" \
    LDFLAGS='-static' \
    CPPFLAGS=-DXXH_NAMESPACE=ZSTD_ \
    PKG_CONFIG_LIBDIR= \
    PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install \
    {PREFIX,prefix}=\"${ridir}\" \
    LDFLAGS='-static' \
    CPPFLAGS=-DXXH_NAMESPACE=ZSTD_ \
    PKG_CONFIG_LIBDIR= \
    PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
