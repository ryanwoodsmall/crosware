rname="elinksminimal"
rver="$(cwver_${rname%%minimal})"
rdir="$(cwdir_${rname%%minimal})"
rfile="$(cwfile_${rname%%minimal})"
rurl="$(cwurl_${rname%%minimal})"
rsha256="$(cwsha256_${rname%%minimal})"
rreqs="bootstrapmake zlib libressl pkgconf"

. "${cwrecipe}/common.sh"

for f in clean fetch extract patch ; do
  eval "function cw${f}_${rname}() { cw${f}_${rname%%minimal} ; }"
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PKG_CONFIG=\"${cwsw}/pkgconf/current/bin/pkgconf\" \
    /bin/bash ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      --disable-{html-highlight,css,xbel,css,nls,gettext} \
      --enable-{ipv6,ftp,gemini,gopher,utf-8,{88,256}-colors,true-color} \
      --without-{x,guile,perl,ruby,libcurl,mujs,quickjs,libevent,libev,gnutls} \
      --with-openssl=\"${cwsw}/libressl/current\" \
      --with-static \
      --with-zlib \
        CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
        PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make ${rlibtool}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  test -e \"\$(cwidir_${rname})/bin/${rname}\" || ln -s elinks \"\$(cwidir_${rname})/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
