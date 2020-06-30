#
# XXX - lua 5.4.0
#

rname="lua"
rver="5.3.5"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.lua.org/ftp/${rfile}"
rsha256="0c2eed3f960446e1a3e4b9a1ca2f3ff893b6ce41942cf54d5dd59ab4b3b058ac"
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
