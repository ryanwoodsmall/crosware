rname="pcre2"
rver="10.41"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://github.com/PCRE2Project/${rname}/releases/download/${rname}-${rver}/${rfile}"
rsha256="0f78cebd3e28e346475fb92e95fe9999945b4cbaad5f3b42aca47b887fb53308"
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
    --enable-pcre2grep-libbz2
  popd >/dev/null 2>&1
}
"
