rname="ntbtls"
rver="0.1.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://gnupg.org/ftp/gcrypt/${rname}/${rfile}"
rsha256="8240db84e50c2351b19eb8064bdfd4d25e3c157d37875c62e335df237d7bdce7"
rreqs="make slibtool libgpgerror libgcrypt libksba zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --with-libgpg-error-prefix=\"${cwsw}/libgpgerror/current\" \
    --with-libgcrypt-prefix=\"${cwsw}/libgcrypt/current\" \
    --with-ksba-prefix=\"${cwsw}/libksba/current\" \
    --with-zlib=\"${cwsw}/zlib/current\" \
      CPPFLAGS=\"-I${cwsw}/libgcrypt/current/include\" \
      LDFLAGS=-static
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
