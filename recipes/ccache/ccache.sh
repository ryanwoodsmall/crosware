rname="ccache"
rver="3.7.5"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/${rname}/${rname}/releases/download/v${rver}/${rfile}"
rsha256="058cc18a25d57c0fd9aa494efdee3cc567b1b60ba1c80a18c5a0128c23832c09"
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
