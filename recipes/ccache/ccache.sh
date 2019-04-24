rname="ccache"
rver="3.7"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/${rname}/${rname}/releases/download/v${rver}/${rfile}"
rsha256="fa3558a75e13b9000ec93140295d119b8075f38bc0ce928b6faa5b34e91d3e30"
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
  ln -sf ${rname} cc
  ln -sf ${rname} c++
  ln -sf ${rname} gcc
  ln -sf ${rname} g++
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
