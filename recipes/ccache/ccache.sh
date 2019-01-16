rname="ccache"
rver="3.5.1"
rdir="${rname}-${rver}"
rfile="${rdir}a.tar.gz"
rurl="https://download.samba.org/pub/${rname}/${rfile}"
rsha256="16cf1b11687083f902ac183ca588c60e8bf1557ba09769fa357d41e29901299b"
rreqs="make"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} --with-bundled-zlib
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install
  cd \"${ridir}/bin\"
  ln -sf ${rname} \${CC}
  ln -sf ${rname} \${CXX}
  ln -sf ${rname} gcc
  ln -sf ${rname} g++
  ln -sf ${rname} cc
  ln -sf ${rname} c++
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
