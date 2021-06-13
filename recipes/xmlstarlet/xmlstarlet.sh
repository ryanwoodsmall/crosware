rname="xmlstarlet"
rver="1.6.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://sourceforge.net/projects/xmlstar/files/${rname}/${rver}/${rfile}/download"
rsha256="15d838c4f3375332fd95554619179b69e4ec91418a3a5296e7c631b7ed19e7ca"
rreqs="make libgcrypt libgpgerror libxml2 libxslt xz zlib configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=\"${cwsw}/libxml2/current/bin:${cwsw}/libxslt/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} \
      --with-libxml-prefix=\"${cwsw}/libxml2/current\" \
      --with-libxslt-prefix=\"${cwsw}/libxslt2/current\" \
        LIBS='-llzma -lz -lgcrypt -lgpg-error'
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install
  ln -sf \"${rtdir}/current/bin/xml\" \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
