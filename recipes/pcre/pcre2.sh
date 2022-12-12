rname="pcre2"
rver="10.42"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://github.com/PCRE2Project/${rname}/releases/download/${rname}-${rver}/${rfile}"
rsha256="8d36cd8cb6ea2a4c2bb358ff6411b0c788633a2a45dabbf1aeb4b701d1b5e840"
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
