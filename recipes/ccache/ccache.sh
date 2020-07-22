rname="ccache"
rver="3.7.11"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/${rname}/${rname}/releases/download/v${rver}/${rfile}"
rsha256="34309a59d4b6b6b33756366aa9d3144a4655587be9f914476b4c0e2d36365f01"
rreqs="bootstrapmake"
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
  ln -sf ${rname} \${CC//-gcc/-cc}
  ln -sf ${rname} \${CXX}
  ln -sf ${rname} \${CXX//-g++/-c++}
  ln -sf ${rname} cc
  ln -sf ${rname} c++
  ln -sf ${rname} gcc
  ln -sf ${rname} g++
  ln -sf ${rname} musl-cc
  ln -sf ${rname} musl-c++
  ln -sf ${rname} musl-gcc
  ln -sf ${rname} musl-g++
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
