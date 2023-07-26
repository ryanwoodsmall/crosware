rname="ibaramg"
rver="7.3"
rdir="mg-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/ibara/mg/releases/download/mg-${rver}/${rfile}"
rsha256="1fd52feed9a96b93ef16c28ec4ff6cb25af85542ec949867bffaddee203d1e95"
rreqs="make libbsd netbsdcurses pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  grep -ril sys/queue . | xargs sed -i.ORIG s,sys/queue,bsd/sys/queue,g
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env CPPFLAGS= LDFLAGS=-static ./configure --enable-static --prefix=\"\$(cwidir_${rname})\" --mandir=\"\$(cwidir_${rname})/share/man\"
  sed -i.ORIG 's/-lncursesw/-lcurses -lterminfo/g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make CPPFLAGS= LDFLAGS=-static CC=\"\${CC} \$(pkg-config --libs --cflags libbsd) -I${cwsw}/netbsdcurses/current/include -L${cwsw}/netbsdcurses/current/lib -Wl,-static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install CPPFLAGS= LDFLAGS=-static CC=\"\${CC} \$(pkg-config --libs --cflags libbsd) -I${cwsw}/netbsdcurses/current/include -L${cwsw}/netbsdcurses/current/lib -Wl,-static\"
  ln -sf mg \"\$(cwidir_${rname})/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
