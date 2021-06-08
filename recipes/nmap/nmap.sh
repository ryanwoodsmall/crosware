#
# XXX - libressl variant
# XXX - fix hard-coded python scripts
#

rname="nmap"
rver="7.91"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://nmap.org/dist/${rfile}"
rsha256="18cc4b5070511c51eb243cdd2b0b30ff9b2c4dc4544c6312f75ce3a67a593300"
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
