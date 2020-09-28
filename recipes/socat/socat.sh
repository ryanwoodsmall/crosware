rname="socat"
rver="1.7.3.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="http://www.dest-unreach.org/${rname}/download/${rfile}"
rsha256="972374ca86f65498e23e3259c2ee1b8f9dbeb04d12c2a78c0c9b5d1cb97dfdfc"
rreqs="make openssl netbsdcurses zlib"

. "${cwrecipe}/common.sh"

# XXX - non-patch versions of alpine fixes
#  https://git.alpinelinux.org/cgit/aports/tree/main/socat
eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --enable-openssl \
    --enable-readline \
    --disable-libwrap \
      CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include -I${cwsw}/netbsdcurses/current/include/readline -I${cwsw}/openssl/current/include -I${cwsw}/zlib/current/include\" \
      LDFLAGS=\"-L${cwsw}/openssl/current/lib -L${cwsw}/netbsdcurses/current/lib -L${cwsw}/zlib/current/lib -static\" \
      LIBS=\"-lreadline -lcurses -lterminfo -lssl -lcrypto -lz\"
  echo '#define NETDB_INTERNAL (-1)' >> compat.h
  sed -i 's#netinet/if_ether#linux/if_ether#g' sysincludes.h
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
