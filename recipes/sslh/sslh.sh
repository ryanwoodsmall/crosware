#
# XXX - libev support for sslh-ev? not sure it's even valid anymore
#

rname="sslh"
rver="1.22c"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/yrutschle/${rname}/archive/refs/tags/${rfile}"
rsha256="ec5f6998f90b2849d113f2617db7ceca5281fbe4ef55fcd185789d390c09eb04"
rreqs="make pcre2 libconfig libcap libbsd pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG \"/^PREFIX/s,PREFIX.*,PREFIX=\$(cwidir_${rname}),g\" Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make -j${cwmakejobs} \
    CC=\"\${CC} \${CFLAGS} \$(pkg-config --{cflags,libs} libbsd)\" \
    ENABLE_REGEX=1 \
    USELIBCONFIG=1 \
    USELIBCAP=1 \
    USELIBBSD=1
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install
  install -m 0755 ${rname}-fork \"\$(cwidir_${rname})/sbin/\"
  install -m 0755 ${rname}-select \"\$(cwidir_${rname})/sbin/\"
  ln -sf ${rname}-fork \"\$(cwidir_${rname})/sbin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
