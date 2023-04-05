rname="cadaver"
rver="0.24"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://notroj.github.io/cadaver/${rfile}"
rsha256="46cff2f3ebd32cd32836812ca47bcc75353fc2be757f093da88c0dd8f10fd5f6"
rreqs="make expat zlib openssl neon netbsdcurses readlinenetbsdcurses"

. "${cwrecipe}/common.sh"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG '/y\\/n/s,;,;fflush(stdout);fflush(stderr);,g' src/cadaver.c src/edit.c
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
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
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
