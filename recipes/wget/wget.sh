rname="wget"
rver="1.20.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.lz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="0f63e84dd23dc53ab3ab6f483c3afff8301e54c165783f772101cdd9b1c64928"
rreqs="make lunzip openssl zlib pcre2 gettexttiny pkgconfig sed expat libmetalink"

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
    --with-metalink \
    --with-openssl=yes \
    --with-zlib \
    --disable-pcre \
    --enable-pcre2 \
    --with-included-libunistring \
    --with-included-regex \
      LIBS='-lexpat'
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  #echo 'alias ${rname}=\"${rtdir}/current/bin/${rname} --no-check-certificate\"' >> \"${rprof}\"
}
"
