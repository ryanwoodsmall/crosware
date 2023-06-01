rname="libxslt"
rver="1.1.38"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://download.gnome.org/sources/${rname}/${rver%.*}/${rfile}"
rsha256="1f32450425819a09acaff2ab7a5a7f8a2ec7956e505d7beeb45e843d0e1ecab1"
rreqs="make libgpgerror libgcrypt libxml2 slibtool xz zlib pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/libxml2/current/bin:${cwsw}/libgcrypt/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
      --with-crypto \
      --with-libxml-prefix=\"${cwsw}/libxml2/current\" \
      --without-python \
      --without-plugins \
        LIBS='-llzma -lz' \
        LIBXML_CFLAGS=\"\$(pkg-config --cflags liblzma zlib libxml-2.0)\" \
        LIBXML_LIBS=\"\$(pkg-config --libs liblzma zlib libxml-2.0)\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
