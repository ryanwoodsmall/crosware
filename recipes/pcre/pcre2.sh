rname="pcre2"
rver="10.35"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://ftp.pcre.org/pub/${rname//2/}/${rfile}"
rsha256="9ccba8e02b0ce78046cdfb52e5c177f0f445e421059e43becca4359c669d4613"
rreqs="make zlib bzip2 readline"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/${rname%2}/${rname%2}.sh.common"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --enable-pcre2-8 \
    --enable-pcre2-16 \
    --enable-pcre2-32 \
    --enable-pcre2grep-libz \
    --enable-pcre2grep-libbz2 \
    --enable-pcre2test-libreadline
  popd >/dev/null 2>&1
}
"
