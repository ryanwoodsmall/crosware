rname="pcre2"
rver="10.39"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://github.com/PhilipHazel/${rname}/releases/download/${rname}-${rver}/${rfile}"
rsha256="0f03caf57f81d9ff362ac28cd389c055ec2bf0678d277349a1a4bee00ad6d440"
rreqs="make zlib bzip2"

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
