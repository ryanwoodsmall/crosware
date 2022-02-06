rname="libssh2wolfssl"
rver="1.9.0"
rdir="wolfssl-osp-libssh2-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/wolfssl/osp/${rfile}"
rsha256="0baeb0980e1e5cc0d4354ad900c71b6c8ac5e9e6218d3de984c267ea01ef4a67"
rreqs="make zlib wolfssl"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --with-crypto=wolfssl \
    --with-wolfssl=\"${cwsw}/wolfssl/current\" \
      CC=\"\${CC} -Os\" \
      CFLAGS=\"-Os -Wl,-s \${CFLAGS}\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{wolfssl,zlib}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{wolfssl,zlib}/current/lib) -static -s\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{wolfssl,zlib}/current/lib/pkgconfig | tr ' ' ':')\"
  sed -i 's/Requires.private/Requires/g' libssh2.pc
  sed -i 's#${ridir}#${rtdir}/current#g' libssh2.pc
  grep -ril '<sys/poll.h>' . | xargs sed -i.ORIG 's#<sys/poll.h>#<poll.h>#g'
  popd >/dev/null 2>&1
}
"
