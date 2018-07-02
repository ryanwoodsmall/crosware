rname="wget"
rver="1.19.5"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.lz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="29fbe6f3d5408430c572a63fe32bd43d5860f32691173dfd84edc06869edca75"
rreqs="make lunzip openssl zlib pcre gettexttiny pkgconfig sed"

. "${cwrecipe}/common.sh"

eval "
function cwextract_${rname}() {
  pushd "${cwbuild}" >/dev/null 2>&1
  cwscriptecho \"extracting ${rfile} in ${cwbuild}\"
  lunzip -dc "${cwdl}/${rname}/${rfile}" | tar -xf -
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --with-ssl=openssl \
    --with-openssl=yes \
    --with-zlib \
    --enable-pcre \
    --with-included-libunistring \
    --with-included-regex
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  #echo 'alias ${rname}=\"${rtdir}/current/bin/${rname} --no-check-certificate\"' >> \"${rprof}\"
}
"
