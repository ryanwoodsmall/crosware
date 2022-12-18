rname="sslhtiny"
rver="$(cwver_sslh)"
rdir="$(cwdir_sslh)"
rbdir="$(cwbdir_sslh)"
rfile="$(cwfile_sslh)"
rdlfile="$(cwdlfile_sslh)"
rurl="$(cwurl_sslh)"
rsha256="$(cwsha256_sslh)"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

for f in clean fetch extract patch ; do
  eval "function cw${f}_${rname} { cw${f}_${rname%tiny} ; }"
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG \"/^PREFIX/s,PREFIX.*,PREFIX=\$(cwidir_${rname}),g\" Makefile
  sed -i s,ENABLE_REGEX=1,ENABLE_REGEX=,g Makefile
  sed -i s,USELIBCONFIG=1,USELIBCONFIG=,g Makefile
  sed -i /^LIBS=/s,-lpcre2-8,,g Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make -j${cwmakejobs} \
    CC=\"\${CC} \${CFLAGS} -Os -g0 -Wl,-s\" \
    LDFLAGS=\"-static -s\" \
    ENABLE_REGEX= \
    USELIBCONFIG= \
    USELIBCAP= \
    USELIBBSD= \
    CPPFLAGS= \
    PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install
  install -m 0755 ${rname%tiny}-fork \"\$(cwidir_${rname})/sbin/${rname}-fork\"
  install -m 0755 ${rname%tiny}-select \"\$(cwidir_${rname})/sbin/${rname}-select\"
  ln -sf ${rname}-fork \"\$(cwidir_${rname})/sbin/${rname%tiny}-fork\"
  ln -sf ${rname}-select \"\$(cwidir_${rname})/sbin/${rname%tiny}-select\"
  ln -sf ${rname}-fork \"\$(cwidir_${rname})/sbin/${rname}\"
  ln -sf ${rname}-fork \"\$(cwidir_${rname})/sbin/${rname%tiny}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/${rname%tiny}/current/sbin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"
