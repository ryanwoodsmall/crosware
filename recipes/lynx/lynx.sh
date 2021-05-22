#
# XXX - libressl variant
#

rname="lynx"
rver="2.8.9rel.1"
rdir="${rname}${rver}"
rfile="${rname}${rver}.tar.bz2"
rurl="https://invisible-mirror.net/archives/${rname}/tarballs/${rfile}"
rsha256="387f193d7792f9cfada14c60b0e5c0bff18f227d9257a39483e14fa1aaf79595"
rreqs="make bzip2 ncurses slang openssl zlib pkgconfig cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

eval "
function cwbuild_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  local commonopts=\"--with-ssl=${cwsw}/openssl/current --without-gnutls --enable-widec --with-pkg-config --with-zlib --with-bzlib --disable-idna\"
  env PATH=\"${cwsw}/pkgconfig/current/bin:\${PATH}\" ./configure ${cwconfigureprefix} --with-screen=ncurses \${commonopts} LIBS=\"-lcrypto -lssl -lz\"
  make
  make install
  mv \"${ridir}/bin/${rname}\" \"${ridir}/bin/${rname}-ncurses\"
  make clean
  env PATH=\"${cwsw}/pkgconfig/current/bin:\${PATH}\" ./configure ${cwconfigureprefix} --with-screen=slang \${commonopts} LIBS=\"-lcrypto -lssl -lz\"
  make
  make install
  mv \"${ridir}/bin/${rname}\" \"${ridir}/bin/${rname}-slang\"
  ln -sf \"${ridir}/bin/${rname}-ncurses\" \"${ridir}/bin/${rname}\"
  sed -i.DEFAULT 's/#ACCEPT_ALL_COOKIES:FALSE/ACCEPT_ALL_COOKIES:TRUE/g' \"${ridir}/etc/lynx.cfg\"
  sed -i 's/#FORCE_SSL_PROMPT:PROMPT/FORCE_SSL_PROMPT:yes/g' \"${ridir}/etc/lynx.cfg\"
  sed -i 's/#FORCE_COOKIE_PROMPT:PROMPT/FORCE_COOKIE_PROMPT:yes/g' \"${ridir}/etc/lynx.cfg\"
  sed -i 's/#NO_PAUSE:FALSE/NO_PAUSE:TRUE/g' \"${ridir}/etc/lynx.cfg\"
  popd >/dev/null 2>&1
}
"

eval "
function cwinstall_${rname}() {
  cwclean_${rname}
  cwfetch_${rname}
  cwcheckreqs_${rname}
  cwsourceprofile
  cwextract_${rname}
  cwbuild_${rname}
  cwlinkdir_${rname}
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
  cwclean_${rname}
}
"
