#
# netbsdcurses:
#  CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include -I${cwsw}/netbsdcurses/current/include/readline\" \
#  LDFLAGS=\"\${LDFLAGS} -L${cwsw}/netbsdcurses/current/lib -static\" \
#  LIBS=\"-lreadline -lcurses -lterminfo -lssl -lcrypto -lz\"
#

rname="socat"
rver="1.7.3.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="http://www.dest-unreach.org/${rname}/download/${rfile}"
rsha256="0dd63ffe498168a4aac41d307594c5076ff307aa0ac04b141f8f1cec6594d04a"
rreqs="make openssl readline zlib"

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
      LIBS='-lssl -lcrypto -lz'
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
