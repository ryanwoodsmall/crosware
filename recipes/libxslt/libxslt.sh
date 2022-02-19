rname="libxslt"
rver="1.1.35"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
#rurl="ftp://xmlsoft.org/${rname}/${rfile}"
#rurl="https://sources.voidlinux.org/${rdir}/${rfile}"
#rurl="http://xmlsoft.org/sources/${rfile}"
rurl="https://download.gnome.org/sources/${rname}/${rver%.*}/${rfile}"
rsha256="8247f33e9a872c6ac859aa45018bc4c4d00b97e2feac9eebc10c93ce1f34dd79"
rreqs="make libgcrypt libxml2 slibtool xz zlib pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=\"${cwsw}/libxml2/current/bin:${cwsw}/libgcrypt/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
      --with-libxml-prefix=\"${cwsw}/libxml2/current\" \
      --without-python \
        LIBS='-llzma -lz' \
        LIBXML_CFLAGS=\"\$(pkg-config --cflags liblzma zlib libxml-2.0)\" \
        LIBXML_LIBS=\"\$(pkg-config --libs liblzma zlib libxml-2.0)\"
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
