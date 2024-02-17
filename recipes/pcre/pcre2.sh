rname="pcre2"
rver="10.43"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/PCRE2Project/${rname}/releases/download/${rname}-${rver}/${rfile}"
rsha256="889d16be5abb8d05400b33c25e151638b8d4bac0e2d9c76e9d6923118ae8a34e"
rreqs="make zlib bzip2"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/${rname%2}/${rname%2}.sh.common"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-pcre2test-lib{edit,readline} \
    --enable-pcre2-8 \
    --enable-pcre2-16 \
    --enable-pcre2-32 \
    --enable-pcre2grep-libz \
    --enable-pcre2grep-libbz2 \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib -static)\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig -static)\"
  popd >/dev/null 2>&1
}
"
