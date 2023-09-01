rname="sslh"
rver="2.0.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/yrutschle/${rname}/archive/refs/tags/${rfile}"
rsha256="45e640dd08f76f0815d000f4b6e7bad376d80c7c3369b73435f2eca73107bc5d"
rreqs="make pcre2 libconfig libcap libbsd pkgconfig libev"

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
  env PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
    make -j${cwmakejobs} \
      CC=\"\${CC} \${CFLAGS} \$(pkg-config --{cflags,libs} libbsd)\" \
      ENABLE_REGEX=1 \
      USELIBCONFIG=1 \
      USELIBCAP=1 \
      USELIBBSD=1 \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include) -DENABLE_REGEX -DLIBCONFIG -DLIBCAP -DLIBBSD\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install
  install -m 0755 ${rname}-fork \"\$(cwidir_${rname})/sbin/\"
  install -m 0755 ${rname}-select \"\$(cwidir_${rname})/sbin/\"
  install -m 0755 ${rname}-ev \"\$(cwidir_${rname})/sbin/\"
  install -m 0755 echosrv \"\$(cwidir_${rname})/sbin/${rname}-echosrv\"
  ln -sf ${rname}-fork \"\$(cwidir_${rname})/sbin/${rname}\"
  ln -sf ${rname}-echosrv \"\$(cwidir_${rname})/sbin/echosrv\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
