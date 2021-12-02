#
# XXX - libressl variant
# XXX - fix hard-coded python scripts
#

rname="nmap"
rver="7.92"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://nmap.org/dist/${rfile}"
rsha256="a5479f2f8a6b0b2516767d2f7189c386c1dc858d997167d7ec5cfc798c7571a1"
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
