rname="sslh"
rver="2.1.1"
rdir="${rname}-v${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.rutschle.net/tech/sslh/${rfile}"
rsha256="0ad3526e072d0f0d4f77ddcdbade4bf315ebd45d468848fd3367996f414d06d7"
rreqs="make pcre2 libconfig libcap libbsd pkgconfig libev"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
    make -j${cwmakejobs} ${rlibtool} \
      CC=\"\${CC} \${CFLAGS} \$(pkg-config --{cflags,libs} libbsd)\" \
      ENABLE_REGEX=1 \
      USELIBCONFIG=1 \
      USELIBCAP=1 \
      USELIBBSD=1 \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include) -DENABLE_REGEX -DLIBCONFIG -DLIBCAP -DLIBBSD\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir tmpinst
  make install DESTDIR=\"\$(cwbdir_${rname})/tmpinst\" ${rlibtool}
  cwmkdir \"\$(cwidir_${rname})\"
  tar -C tmpinst/usr/ -cf - . | tar -C \"\$(cwidir_${rname})/\" -xvf -
  install -m 755 echosrv \"$(cwidir_${rname})/sbin/echosrv\"
  install -m 755 sslh-ev \"$(cwidir_${rname})/sbin/sslh-ev\"
  install -m 755 sslh-fork \"$(cwidir_${rname})/sbin/sslh-fork\"
  install -m 755 sslh-select \"$(cwidir_${rname})/sbin/sslh-select\"
  ln -sf sslh-fork \"$(cwidir_${rname})/sbin/sslh\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
