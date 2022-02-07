rname="ntbtls"
rver="0.3.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://gnupg.org/ftp/gcrypt/${rname}/${rfile}"
rsha256="d1d9c86fc31e8154657a4c01ec6da17628c75c0ea5d43388956305e3067c7d46"
rreqs="make slibtool libgpgerror libgcrypt libksba zlib configgit"

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
