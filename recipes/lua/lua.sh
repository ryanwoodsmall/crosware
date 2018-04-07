rname="lua"
rver="5.3.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.lua.org/ftp/${rfile}"
rsha256="f681aa518233bc407e23acf0f5887c884f17436f000d453b2491a9f11a52400c"
rreqs="make ncurses readline"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG \"s#^INSTALL_TOP=.*#INSTALL_TOP= ${ridir}#g\" Makefile
  sed -i.ORIG \"s#^CC= gcc #CC= \${CC} #g\" src/Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make -j${cwmakejobs} posix MYCFLAGS=\"\${CFLAGS} \${CPPFLAGS} \" MYLDFLAGS=\"\${LDFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
