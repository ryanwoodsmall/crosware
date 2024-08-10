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
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    C{,XX}FLAGS=\"\${CFLAGS} -Wl,-s -g0 -Os\" \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
    make -j${cwmakejobs} ${rlibtool} \
      CC=\"\${CC} \${CFLAGS} -Os -g0 -Wl,-s \$(pkg-config --{cflags,libs} libbsd)\" \
      ENABLE_REGEX=1 \
      USELIBCONFIG=1 \
      USELIBBSD=1 \
      USELIBCAP= \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include) -DENABLE_REGEX -DLIBCONFIG -DLIBBSD\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir tmpinst
  make install DESTDIR=\"\$(cwbdir_${rname})/tmpinst\" ${rlibtool}
  cwmkdir \"\$(cwidir_${rname})\"
  tar -C tmpinst/usr/ -cf - . | tar -C \"\$(cwidir_${rname})/\" -xvf -
  install -m 755 echosrv \"$(cwidir_${rname})/sbin/echosrv\"
  install -m 755 sslh-ev \"$(cwidir_${rname})/sbin/sslh-ev\"
  install -m 755 sslh-fork \"$(cwidir_${rname})/sbin/sslh-fork\"
  install -m 755 sslh-select \"$(cwidir_${rname})/sbin/sslh-select\"
  ln -sf sslh-fork \"$(cwidir_${rname})/sbin/sslh\"
  ln -sf sslh \"$(cwidir_${rname})/sbin/${rname}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/${rname%minimal}/current/sbin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"
