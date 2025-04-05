#
# XXX - removed ${rname}-${p} symlinks... hmm. might be better as a plan9 `9`-like wrapper?
# XXX - do other recipes need this? baseutils, outils, ...
# XXX - bearssl libtls in use here - not extensively tested...
# XXX - make libressl default? libretls (openssl) and libtlsbearssl variants?
#
rname="otools"
rver="1.5.1"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/CarbsLinux/${rname}/archive/refs/tags/${rfile}"
rsha256="37dfe4f0ae14a9acf1453661f8c9afb2a2cf0a3c8bdb80abd51a7c5722479b08"
rreqs="bootstrapmake zlib bearssl libtlsbearssl muslfts pkgconf"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
    CC=\"\${CC} \${CFLAGS} \$(echo -I${cwsw}/{${rreqs// /,}}/current/include) \$(echo -L${cwsw}/{${rreqs// /,}}/current/lib)\" \
    PKG_CONFIG=\"${cwsw}/pkgconf/current/bin/pkgconf\" \
      ./configure ${cwconfigureprefix} \
        --with-fts=musl-fts \
        --with-less-t=no \
        --with-netcat=yes \
        --with-system-zlib
  cat Makefile > Makefile.ORIG
  sed -i 's,-include /usr/include/tls.h,,g' Makefile
  sed -i 's,ln -s,ln -sf,g' Makefile
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make ${rlibtool} \
    CC=\"\${CC} \${CFLAGS} \$(echo -I${cwsw}/{${rreqs// /,}}/current/include) \$(echo -L${cwsw}/{${rreqs// /,}}/current/lib)\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool} \
    CC=\"\${CC} \${CFLAGS} \$(echo -I${cwsw}/{${rreqs// /,}}/current/include) \$(echo -L${cwsw}/{${rreqs// /,}}/current/lib)\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
