rname="libxslt"
rver="1.1.33"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="ftp://xmlsoft.org/${rname}/${rfile}"
rsha256="8e36605144409df979cab43d835002f63988f3dc94d5d3537c12796db90e38c8"
rreqs="make libgcrypt libxml2 slibtool xz zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=\"${cwsw}/libxml2/current/bin:${cwsw}/libgcrypt/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
      --with-libxml-prefix=\"${cwsw}/libxml2/current\" \
      --without-python \
        LIBS='-llzma -lz'
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
