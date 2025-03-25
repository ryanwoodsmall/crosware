rname="libxslt"
rver="1.1.43"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://download.gnome.org/sources/${rname}/${rver%.*}/${rfile}"
rsha256="5a3d6b383ca5afc235b171118e90f5ff6aa27e9fea3303065231a6d403f0183a"
rreqs="make libgpgerror libgcrypt libxml2 slibtool xz zlib pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=\"${cwsw}/libxml2/current/bin:${cwsw}/libgcrypt/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
      --with-crypto \
      --with-libxml-prefix=\"${cwsw}/libxml2/current\" \
      --without-python \
      --without-plugins \
        LIBS='-llzma -lz' \
        LIBXML_CFLAGS=\"\$(pkg-config --cflags liblzma zlib libxml-2.0)\" \
        LIBXML_LIBS=\"\$(pkg-config --libs liblzma zlib libxml-2.0)\" \
        CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
        PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd &>/dev/null
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
