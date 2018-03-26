rname="lynx"
rver="2.8.9dev.17"
rdir="${rname}${rver}"
rfile="${rname}${rver}.tar.bz2"
rurl="ftp://ftp.invisible-island.net/${rname}/tarballs/${rfile}"
rsha256="a43811b9078c46ccd6d91a3d5ae0a8bc1f247a4dd89c1a6ccdbcd6c2b3d56ed3"
rreqs="make slang ncurses openssl zlib"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"

eval "
function cwbuild_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  local commonopts=\"--with-ssl --enable-widec --with-zlib\"
  ./configure ${cwconfigureprefix} --with-screen=ncurses \${commonopts} LIBS=\"-lcrypto -lssl -lz\"
  make
  make install
  mv "${ridir}/bin/${rname}" "${ridir}/bin/${rname}-ncurses"
  make clean
  ./configure ${cwconfigureprefix} --with-screen=slang \${commonopts} LIBS=\"-lcrypto -lssl -lz\"
  make
  make install
  mv "${ridir}/bin/${rname}" "${ridir}/bin/${rname}-slang"
  ln -sf "${ridir}/bin/${rname}-ncurses" "${ridir}/bin/${rname}"
  sed -i.DEFAULT 's/#ACCEPT_ALL_COOKIES:FALSE/ACCEPT_ALL_COOKIES:TRUE/g' "${ridir}/etc/lynx.cfg"
  sed -i 's/#FORCE_SSL_PROMPT:PROMPT/FORCE_SSL_PROMPT:no/g' "${ridir}/etc/lynx.cfg"
  popd >/dev/null 2>&1
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwcheckreqs_${rname}
  cwsourceprofile
  cwclean_${rname}
  cwextract_${rname}
  cwbuild_${rname}
  cwlinkdir "${rdir}" "${rtdir}"
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
  cwclean_${rname}
}
"
