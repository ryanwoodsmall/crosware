rname="lynxminimal"
rver="$(cwver_lynx)"
rdir="$(cwdir_lynx)"
rfile="$(cwfile_lynx)"
rdlfile="$(cwdlfile_lynx)"
rurl="$(cwurl_lynx)"
rsha256=""
rreqs="bootstrapmake libressl zlib slangminimal"

. "${cwrecipe}/common.sh"

for f in fetch clean extract make ; do
  eval "function cw${f}_${rname}() { cw${f}_lynx ; }"
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --without-gnutls \
    --with-screen=slang \
    --with-ssl=\"${cwsw}/libressl/current\" \
    --with-zlib \
    --without-bzlib \
    --without-pkg-config \
    --disable-idna \
      CFLAGS=\"\${CFLAGS} -Os -g0 -Wl,-s\" \
      CXXFLAGS=\"\${CXXFLAGS} -Os -g0 -Wl,-s\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -s -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  rm -f \$(cwidir_${rname})/bin/lynx*
  make install ${rlibtool}
  \$(\${CC} -dumpmachine)-strip --strip-all \"\$(cwidir_${rname})/bin/lynx\"
  test -e \"\$(cwidir_${rname})/bin/${rname}\" || ln -sf \"${rtdir}/current/bin/lynx\" \"\$(cwidir_${rname})/bin/${rname}\"
  sed -i.DEFAULT 's/#ACCEPT_ALL_COOKIES:FALSE/ACCEPT_ALL_COOKIES:TRUE/g' \"\$(cwidir_${rname})/etc/lynx.cfg\"
  sed -i 's/#FORCE_SSL_PROMPT:PROMPT/FORCE_SSL_PROMPT:yes/g' \"\$(cwidir_${rname})/etc/lynx.cfg\"
  sed -i 's/#FORCE_COOKIE_PROMPT:PROMPT/FORCE_COOKIE_PROMPT:yes/g' \"\$(cwidir_${rname})/etc/lynx.cfg\"
  sed -i 's/#NO_PAUSE:FALSE/NO_PAUSE:TRUE/g' \"\$(cwidir_${rname})/etc/lynx.cfg\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
