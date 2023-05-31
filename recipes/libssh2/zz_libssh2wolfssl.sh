rname="libssh2wolfssl"
rver="$(cwver_libssh2)"
rdir="$(cwdir_libssh2)"
rfile="$(cwfile_libssh2)"
rdlfile="$(cwdlfile_libssh2)"
rurl="$(cwurl_libssh2)"
rsha256="$(cwsha256_libssh2)"
rreqs="make zlib wolfssl"

. "${cwrecipe}/common.sh"

for f in clean fetch extract patch make makeinstall ; do
  eval "function cw${f}_${rname}() { cw${f}_${rname%wolfssl} ; }"
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-{,{sshd,docker}-}tests \
    --disable-examples-build \
    --with-crypto=wolfssl \
    --with-libz \
    --with-libwolfssl-prefix=\"${cwsw}/wolfssl/current\" \
    --with-libz-prefix=\"${cwsw}/zlib/current\" \
      CC=\"\${CC} -Os\" \
      CFLAGS=\"-Os -Wl,-s \${CFLAGS}\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  sed -i 's/Requires.private/Requires/g' libssh2.pc
  sed -i \"s#\$(cwidir_${rname})#${rtdir}/current#g\" libssh2.pc
  grep -ril '<sys/poll.h>' . | xargs sed -i.ORIG 's#<sys/poll.h>#<poll.h>#g'
  popd >/dev/null 2>&1
}
"
