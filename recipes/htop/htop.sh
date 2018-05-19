rname="htop"
rver="2.2.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://hisham.hm/${rname}/releases/${rver}/${rfile}"
rsha256="d9d6826f10ce3887950d709b53ee1d8c1849a70fa38e91d5896ad8cbc6ba3c57"
rreqs="make ncurses python2"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} CC=\"\${CC} \${CFLAGS} \${LDFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ln -s \${cwsw}/python2/current/bin buildbin
  env PATH=\"./buildbin:\${PATH}\" make -j${cwmakejobs}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=\"./buildbin:\${PATH}\" make install
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
