rname="nmap"
rver="7.80"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://nmap.org/dist/${rfile}"
rsha256="fcfa5a0e42099e12e4bf7a68ebe6fde05553383a682e816a7ec9256ab4773faa"
rreqs="make openssl python2 zlib slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure --prefix=\"${ridir}\" \
    --disable-nls \
    --with-ndiff \
    --with-openssl=\"${cwsw}/openssl/current\" \
    --with-libdnet=included \
    --with-liblinear=included \
    --with-liblua=included \
    --with-libpcap=included \
    --with-libpcre=included \
    --with-libssh2=included \
      LIBS='-lssl -lcrypto -lz -static'
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
