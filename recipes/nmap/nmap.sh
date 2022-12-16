#
# XXX - libressl variant
# XXX - fix hard-coded python scripts
#

rname="nmap"
rver="7.93"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://nmap.org/dist/${rfile}"
rsha256="55bcfe4793e25acc96ba4274d8c4228db550b8e8efd72004b38ec55a2dd16651"
rreqs="make openssl python2 zlib slibtool configgit"

. "${cwrecipe}/common.sh"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG 's,^#if OPENSSL_API_LEVEL.*,#if 0,g' ncat/http_digest.c
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure --prefix=\"\$(cwidir_${rname})\" \
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
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make ${rlibtool}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
