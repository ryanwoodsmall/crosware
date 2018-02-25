rname="lynx"
rver="2.8.8rel.2"
rdir="${rname}2-8-8"
rfile="${rname}${rver}.tar.gz"
rurl="ftp://ftp.invisible-island.net/${rname}/tarballs/${rfile}"
rsha256="234c9dc77d4c4594ad6216d7df4d49eae3019a3880e602f39721b35b97fbc408"
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
  local commonopts=\"--with-ssl --enable-widec --with-zlib LIBS=\'-lssl -lcrypto -lz\'\"
  #./configure ${cwconfigureprefix} --with-screen=ncursesw \${commonopts} 
  #make
  #make install
  #mv "${ridir}/bin/${rname}" "${ridir}/bin/${rname}-ncurses"
  #make clean
  ./configure ${cwconfigureprefix} --with-screen=slang \${commonopts}
  make
  make install
  sed -i.DEFAULT 's/#ACCEPT_ALL_COOKIES:FALSE/ACCEPT_ALL_COOKIES:TRUE/g' "${ridir}/etc/lynx.cfg"
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
