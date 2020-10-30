#
# XXX - lua 5.4.0
#

rname="lua"
rver="5.3.6"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.lua.org/ftp/${rfile}"
rsha256="fc5fd69bb8736323f026672b1b7235da613d7177e72558893a0bdcd320466d60"
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
