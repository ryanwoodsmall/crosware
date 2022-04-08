rname="ntbtls"
rver="0.3.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://gnupg.org/ftp/gcrypt/${rname}/${rfile}"
rsha256="8922181fef523b77b71625e562e4d69532278eabbd18bc74579dbe14135729ba"
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
