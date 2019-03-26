#
# XXX
#   compile with libgcrypt?
#   allow linking into curl with openssl/mbedtls/wolfssl?
#   libgit2 support down the road?
#

rname="libssh2"
rver="1.8.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.libssh2.org/download/${rfile}"
rsha256="088307d9f6b6c4b8c13f34602e8ff65d21c2dc4d55284dfe15d502c4ee190d67"
rreqs="make openssl zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --with-openssl --with-libz
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_cppflags \"-I${rtdir}/current/include\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
