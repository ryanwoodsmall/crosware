rname="pcre"
rver="8.44"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://ftp.pcre.org/pub/${rname}/${rfile}"
rsha256="19108658b23b3ec5058edc9f66ac545ea19f9537234be1ec62b714c84399366d"
rreqs="make zlib bzip2 slibtool"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/${rname}/${rname}.sh.common"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-pcretest-lib{edit,readline} \
    --enable-pcre8 \
    --enable-pcre16 \
    --enable-pcre32 \
    --enable-pcregrep-libz \
    --enable-pcregrep-libbz2 \
    --enable-unicode-properties \
    --enable-utf
  popd >/dev/null 2>&1
}
"
