rname="libssh2mbedtls"
rver="$(cwver_libssh2)"
rdir="${rname%mbedtls}-${rver}"
rfile="${rdir}.tar.gz"
rdlfile="${cwdl}/${rname%mbedtls}/${rfile}"
rurl=""
rsha256=""
rreqs="make zlib mbedtls"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetch_${rname%mbedtls}
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --with-crypto=mbedtls \
    --with-libmbedcrypto-prefix=\"${cwsw}/mbedtls/current\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{mbedtls,zlib}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{mbedtls,zlib}/current/lib) -static\" \
      LIBS=\"-lmbedx509 -lmbedtls -lmbedcrypto -lz -static\"
  sed -i 's/Requires.private/Requires/g' libssh2.pc
  sed -i 's#${ridir}#${rtdir}/current#g' libssh2.pc
  sed -i '/^Libs:/s|\$| -lmbedx509 -lmbedtls -lmbedcrypto -lz|g' libssh2.pc
  grep -ril '<sys/poll.h>' . | xargs sed -i.ORIG 's#<sys/poll.h>#<poll.h>#g'
  popd >/dev/null 2>&1
}
"
