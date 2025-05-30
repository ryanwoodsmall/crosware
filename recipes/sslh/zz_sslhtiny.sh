rname="sslhtiny"
rver="$(cwver_sslh)"
rdir="$(cwdir_sslh)"
rbdir="$(cwbdir_sslh)"
rfile="$(cwfile_sslh)"
rdlfile="$(cwdlfile_sslh)"
rurl="$(cwurl_sslh)"
rsha256="$(cwsha256_sslh)"
rreqs="bootstrapmake pcre2 libproxyprotocol"

. "${cwrecipe}/common.sh"

for f in clean fetch extract patch ; do
  eval "function cw${f}_${rname} { cw${f}_${rname%tiny} ; }"
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i s,^USELIBCONFIG=1,USELIBCONFIG=0,g Makefile.in
  sed -i s,^USELIBEV=1,USELIBEV=0,g Makefile.in
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
  make -j${cwmakejobs} ${rlibtool} \
    USELIB{BSD,CONFIG,EV}= \
    CC=\"\${CC} \${CFLAGS} -Os -g0 -Wl,-s\" \
    C{,XX}FLAGS=\"\${CFLAGS} -Wl,-s -g0 -Os\" \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include -UUSELIB{BSD,CONFIG,EV} -DHAVE_PROXYPROTOCOL=1)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir tmpinst
  make install DESTDIR=\"\$(cwbdir_${rname})/tmpinst\" ${rlibtool} \
    USELIB{BSD,CONFIG,EV}= \
    CC=\"\${CC} \${CFLAGS} -Os -g0 -Wl,-s\" \
    C{,XX}FLAGS=\"\${CFLAGS} -Wl,-s -g0 -Os\" \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include -UUSELIB{BSD,CONFIG,EV} -DHAVE_PROXYPROTOCOL)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  cwmkdir \"\$(cwidir_${rname})\"
  tar -C tmpinst/usr/ -cf - . | tar -C \"\$(cwidir_${rname})/\" -xvf -
  install -m 755 echosrv \"$(cwidir_${rname})/sbin/echosrv\"
  install -m 755 sslh-fork \"$(cwidir_${rname})/sbin/sslh-fork\"
  install -m 755 sslh-select \"$(cwidir_${rname})/sbin/sslh-select\"
  ln -sf sslh-fork \"$(cwidir_${rname})/sbin/sslh\"
  ln -sf sslh \"$(cwidir_${rname})/sbin/${rname}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/${rname%tiny}/current/sbin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"
