rname="libssh2libgcrypt"
rver="$(cwver_libssh2)"
rdir="${rname%libgcrypt}-${rver}"
rfile="${rdir}.tar.gz"
rdlfile="${cwdl}/${rname%libgcrypt}/${rfile}"
rurl=""
rsha256=""
rreqs="make zlib libgpgerror libgcrypt"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetch_${rname%libgcrypt}
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --with-crypto=libgcrypt \
    --with-libgcrypt-prefix=\"${cwsw}/libgcrypt/current\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{libgcrypt,libgpgerror,zlib}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{libgcrypt,libgpgerror,zlib}/current/lib) -static\" \
      LIBS=\"-lgcrypt -lgpg-error -lz -static\"
  sed -i 's/Requires.private/Requires/g' libssh2.pc
  sed -i 's#${ridir}#${rtdir}/current#g' libssh2.pc
  sed -i '/^Libs:/s|\$| -lgcrypt -lgpg-error -lz|g' libssh2.pc
  grep -ril '<sys/poll.h>' . | xargs sed -i.ORIG 's#<sys/poll.h>#<poll.h>#g'
  popd >/dev/null 2>&1
}
"
