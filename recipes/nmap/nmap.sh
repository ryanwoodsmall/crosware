rname="nmap"
rver="7.90"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://nmap.org/dist/${rfile}"
rsha256="5557c3458275e8c43e1d0cfa5dad4e71dd39e091e2029a293891ad54098a40e8"
rreqs="make openssl python2 zlib slibtool configgit"

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
