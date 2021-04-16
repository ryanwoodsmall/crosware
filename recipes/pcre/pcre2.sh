rname="pcre2"
rver="10.36"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://ftp.pcre.org/pub/${rname//2/}/${rfile}"
rsha256="a9ef39278113542968c7c73a31cfcb81aca1faa64690f400b907e8ab6b4a665c"
rreqs="make zlib bzip2 "

. "${cwrecipe}/common.sh"
. "${cwrecipe}/${rname%2}/${rname%2}.sh.common"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
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
