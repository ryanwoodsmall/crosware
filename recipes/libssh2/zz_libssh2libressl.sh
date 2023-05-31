#
# XXX - need to fixup lib/libssh2.la, replace libressl-#.#.# (and zlib-#.#.#) versioned dirs with current
#
rname="libssh2libressl"
rver="$(cwver_libssh2)"
rdir="$(cwdir_libssh2)"
rfile="$(cwfile_libssh2)"
rdlfile="$(cwdlfile_libssh2)"
rurl="$(cwurl_libssh2)"
rsha256="$(cwsha256_libssh2)"
rreqs="make zlib libressl"

. "${cwrecipe}/common.sh"

for f in clean fetch extract patch make makeinstall ; do
  eval "function cw${f}_${rname}() { cw${f}_${rname%libressl} ; }"
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-{,{sshd,docker}-}tests \
    --disable-examples-build \
    --with-crypto=openssl \
    --with-pic \
    --with-libz \
    --with-libssl-prefix=\"${cwsw}/libressl/current\" \
    --with-libz-prefix=\"${cwsw}/zlib/current\" \
      CC=\"\${CC} -Os\" \
      CFLAGS=\"-Os -Wl,-s \${CFLAGS}\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      LIBS=\"-lz -static\"
  sed -i 's/Requires.private/Requires/g' libssh2.pc
  sed -i \"s#\$(cwidir_${rname})#${rtdir}/current#g\" libssh2.pc
  sed -i '/^Libs:/s|\$| -L${cwsw}/libressl/current/lib -lssl -lcrypto -L${cwsw}/zlib/current/lib -lz|g' libssh2.pc
  grep -ril '<sys/poll.h>' . | xargs sed -i.ORIG 's#<sys/poll.h>#<poll.h>#g'
  popd >/dev/null 2>&1
}
"
