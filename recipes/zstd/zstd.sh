#
# XXX - 1.5.7 needs qsort_r or a workaround
# XXX - newer musl required, patch below BUT all downstream stuff then needs muslstandalone
#
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

# XXX - cut here
# diff --git a/recipes/zstd/zstd.sh b/recipes/zstd/zstd.sh
# index 4a99564d1..e0f839bb6 100644
# --- a/recipes/zstd/zstd.sh
# +++ b/recipes/zstd/zstd.sh
# @@ -1,10 +1,10 @@
#  rname="zstd"
# -rver="1.5.6"
# +rver="1.5.7"
#  rdir="${rname}-${rver}"
#  rfile="${rdir}.tar.gz"
#  rurl="https://github.com/facebook/${rname}/releases/download/v${rver}/${rfile}"
# -rsha256="8c29e06cf42aacc1eafc4077ae2ec6c6fcb96a626157e0593d5e82a34fd403c1"
# -rreqs="make"
# +rsha256="eb33e51f49a15e023950cd7825ca74a4a2b43db8354825ac24fc1b7ee09e6fa3"
# +rreqs="make muslstandalone busybox bashtiny"
#
#  . "${cwrecipe}/common.sh"
#
# @@ -23,12 +23,15 @@ function cwconfigure_${rname}() {
#  eval "
#  function cwmake_${rname}() {
#    pushd \"\$(cwbdir_${rname})\" &>/dev/null
# -  make \
# -    {PREFIX,prefix}=\"\$(cwidir_${rname})\" \
# -    LDFLAGS='-static' \
# -    CPPFLAGS=-DXXH_NAMESPACE=ZSTD_ \
# -    PKG_CONFIG_LIBDIR= \
# -    PKG_CONFIG_PATH=
# +  (
# +    export PATH=\"\$(echo ${cwsw}/{ccache4,ccache,muslstandalone,statictoolchain,bashtiny,busybox,make}/current/bin | tr ' ' ':')\"
# +    make \
# +      {PREFIX,prefix}=\"\$(cwidir_${rname})\" \
# +      LDFLAGS='-static' \
# +      CPPFLAGS=-DXXH_NAMESPACE=ZSTD_ \
# +      PKG_CONFIG_LIBDIR= \
# +      PKG_CONFIG_PATH=
# +  )
#    popd &>/dev/null
#  }
#  "
# @@ -36,12 +39,15 @@ function cwmake_${rname}() {
#  eval "
#  function cwmakeinstall_${rname}() {
#    pushd \"\$(cwbdir_${rname})\" &>/dev/null
# -  make install \
# -    {PREFIX,prefix}=\"\$(cwidir_${rname})\" \
# -    LDFLAGS='-static' \
# -    CPPFLAGS=-DXXH_NAMESPACE=ZSTD_ \
# -    PKG_CONFIG_LIBDIR= \
# -    PKG_CONFIG_PATH=
# +  (
# +    export PATH=\"\$(echo ${cwsw}/{ccache4,ccache,muslstandalone,statictoolchain,bashtiny,busybox,make}/current/bin | tr ' ' ':')\"
# +    make install \
# +      {PREFIX,prefix}=\"\$(cwidir_${rname})\" \
# +      LDFLAGS='-static' \
# +      CPPFLAGS=-DXXH_NAMESPACE=ZSTD_ \
# +      PKG_CONFIG_LIBDIR= \
# +      PKG_CONFIG_PATH=
# +  )
#    popd &>/dev/null
#  }
#  "
