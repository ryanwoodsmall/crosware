rname="ibaramg"
rver="7.0"
rdir="mg-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/ibara/mg/releases/download/mg-${rver}/${rfile}"
rsha256="650dbdf9c9a72ec1922486ce07112d6181fc88a30770913d71d5c99c57fb2ac5"
rreqs="make libbsd netbsdcurses pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwpatch_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  grep -ril sys/queue . | xargs sed -i.ORIG s,sys/queue,bsd/sys/queue,g
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env CPPFLAGS= LDFLAGS=-static ./configure --enable-static --prefix=\"${ridir}\" --mandir=\"${ridir}/share/man\"
  sed -i.ORIG 's/-lncursesw/-lcurses -lterminfo/g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make CPPFLAGS= LDFLAGS=-static CC=\"\${CC} \$(pkg-config --libs --cflags libbsd) -I${cwsw}/netbsdcurses/current/include -L${cwsw}/netbsdcurses/current/lib -Wl,-static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install CPPFLAGS= LDFLAGS=-static CC=\"\${CC} \$(pkg-config --libs --cflags libbsd) -I${cwsw}/netbsdcurses/current/include -L${cwsw}/netbsdcurses/current/lib -Wl,-static\"
  ln -sf mg \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
