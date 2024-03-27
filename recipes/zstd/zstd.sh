rname="zstd"
rver="1.5.6"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/facebook/${rname}/releases/download/v${rver}/${rfile}"
rsha256="8c29e06cf42aacc1eafc4077ae2ec6c6fcb96a626157e0593d5e82a34fd403c1"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cp lib/Makefile{,.ORIG}
  cp Makefile{,.ORIG}
  sed -i '/^lib/s/libzstd.a libzstd/libzstd.a/g' lib/Makefile
  sed -i '/^install:/s/install-shared//g' lib/Makefile
  sed -i '/^allmost:/s/zlibwrapper//g' Makefile
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make \
    {PREFIX,prefix}=\"\$(cwidir_${rname})\" \
    LDFLAGS='-static' \
    CPPFLAGS=-DXXH_NAMESPACE=ZSTD_ \
    PKG_CONFIG_LIBDIR= \
    PKG_CONFIG_PATH=
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install \
    {PREFIX,prefix}=\"\$(cwidir_${rname})\" \
    LDFLAGS='-static' \
    CPPFLAGS=-DXXH_NAMESPACE=ZSTD_ \
    PKG_CONFIG_LIBDIR= \
    PKG_CONFIG_PATH=
  popd &>/dev/null
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
