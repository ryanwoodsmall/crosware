#
# XXX - remove newer neon 0.33.x+ workaround
# XXX - use cwappendfunc in other tls lib variants instead of full cwmakeinstall_
#
rname="cadaver"
rver="0.26"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://notroj.github.io/cadaver/${rfile}"
rsha256="9236e43cdf3505d9ef06185fda43252840105c0c02d9370b6e1077d866357b55"
rreqs="make expat zlib openssl neon netbsdcurses readlinenetbsdcurses"

. "${cwrecipe}/common.sh"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG '/y\\/n/s,;,;fflush(stdout);fflush(stderr);,g' src/cadaver.c src/edit.c
  : sed -i.ORIG 's, 31 32, 31 32 33 34,g' configure
  popd &>/dev/null
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=\"${cwsw}/neon${rname#cadaver}/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      --disable-nls \
      --enable-readline \
      --with-ca-bundle=\"${cwetc}/ssl/cert.pem\" \
      --with-neon=\"${cwsw}/neon${rname#cadaver}/current\" \
      --with-ssl=openssl \
      --without-{egd,gssapi,lib{iconv,intl}-prefix,libproxy,pakchois} \
        CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
        PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
        LIBS='-lreadline -lcurses -lterminfo'
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
