rname="sslhminimal"
rver="$(cwver_sslh)"
rdir="$(cwdir_sslh)"
rbdir="$(cwbdir_sslh)"
rfile="$(cwfile_sslh)"
rdlfile="$(cwdlfile_sslh)"
rurl="$(cwurl_sslh)"
rsha256="$(cwsha256_sslh)"
rreqs="make pcre2 libconfig libbsd pkgconfig libev"

. "${cwrecipe}/common.sh"

for f in clean fetch extract patch ; do
  eval "function cw${f}_${rname} { cw${f}_${rname%minimal} ; }"
done
unset f

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
      CC=\"\${CC} \${CFLAGS} -Os -g0 -Wl,-s \$(pkg-config --{cflags,libs} libbsd)\" \
      ENABLE_REGEX=1 \
      USELIBCONFIG=1 \
      USELIBBSD=1 \
      USELIBCAP= \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include) -DENABLE_REGEX -DLIBCONFIG -DLIBBSD\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install
  install -m 0755 ${rname%minimal}-fork \"\$(cwidir_${rname})/sbin/${rname}-fork\"
  install -m 0755 ${rname%minimal}-select \"\$(cwidir_${rname})/sbin/${rname}-select\"
  install -m 0755 ${rname%minimal}-ev \"\$(cwidir_${rname})/sbin/${rname}-ev\"
  install -m 0755 echosrv \"\$(cwidir_${rname})/sbin/${rname}-echosrv\"
  ln -sf ${rname}-fork \"\$(cwidir_${rname})/sbin/${rname%minimal}-fork\"
  ln -sf ${rname}-select \"\$(cwidir_${rname})/sbin/${rname%minimal}-select\"
  ln -sf ${rname}-ev \"\$(cwidir_${rname})/sbin/${rname%minimal}-ev\"
  ln -sf ${rname}-fork \"\$(cwidir_${rname})/sbin/${rname}\"
  ln -sf ${rname}-fork \"\$(cwidir_${rname})/sbin/${rname%minimal}\"
  ln -sf ${rname}-echosrv \"\$(cwidir_${rname})/sbin/echosrv\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/${rname%minimal}/current/sbin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"
