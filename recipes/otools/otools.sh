#
# XXX - ${rname}-${p} symlink... hmm. might be better as a plan9 `9`-like wrapper?
# XXX - do other receipes need this? baseutils, outils, ...
# XXX - bearssl libtls in use here - not extensively tested...
# XXX - make libressl default? libretls (openssl) and libtlsbearssl variants?
# XXX - turn on muslfts support?
# XXX - otools- symlinks are kind of annoying, eliminate?
#
rname="otools"
rver="1.5.1"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/CarbsLinux/${rname}/archive/refs/tags/${rfile}"
rsha256="37dfe4f0ae14a9acf1453661f8c9afb2a2cf0a3c8bdb80abd51a7c5722479b08"
rreqs="bootstrapmake zlib bearssl libtlsbearssl pkgconfig"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
    CC=\"\${CC} \${CFLAGS} \$(echo -I${cwsw}/{${rreqs// /,}}/current/include) \$(echo -L${cwsw}/{${rreqs// /,}}/current/lib)\" \
      ./configure ${cwconfigureprefix} \
        --with-fts=none \
        --with-less-t=no \
        --with-netcat=yes \
        --with-system-zlib
  cat Makefile > Makefile.ORIG
  sed -i 's,-include /usr/include/tls.h,,g' Makefile
  sed -i 's,ln -s,ln -sf,g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make ${rlibtool} \
    CC=\"\${CC} \${CFLAGS} \$(echo -I${cwsw}/{${rreqs// /,}}/current/include) \$(echo -L${cwsw}/{${rreqs// /,}}/current/lib)\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool} \
    CC=\"\${CC} \${CFLAGS} \$(echo -I${cwsw}/{${rreqs// /,}}/current/include) \$(echo -L${cwsw}/{${rreqs// /,}}/current/lib)\"
  cd \"\$(cwidir_${rname})/bin/\"
  for p in \$(find . ! -type d | grep -v ${rname}-) ; do
    rm -f ${rname}-\${p}
    ln -sf \${p} ${rname}-\$(basename \${p})
  done
  cd -
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
