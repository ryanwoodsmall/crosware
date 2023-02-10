rname="zstd"
rver="1.5.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/facebook/${rname}/releases/download/v${rver}/${rfile}"
rsha256="0f470992aedad543126d06efab344dc5f3e171893810455787d38347343a4424"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
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
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make \
    {PREFIX,prefix}=\"\$(cwidir_${rname})\" \
    LDFLAGS='-static' \
    CPPFLAGS=-DXXH_NAMESPACE=ZSTD_ \
    PKG_CONFIG_LIBDIR= \
    PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install \
    {PREFIX,prefix}=\"\$(cwidir_${rname})\" \
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
