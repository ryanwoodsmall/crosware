rname="libxslt"
rver="1.1.34"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="ftp://xmlsoft.org/${rname}/${rfile}"
#rurl="https://sources.voidlinux.org/${rdir}/${rfile}"
rurl="http://xmlsoft.org/sources/${rfile}"
rsha256="98b1bd46d6792925ad2dfe9a87452ea2adebf69dcb9919ffd55bf926a7f93f7f"
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
