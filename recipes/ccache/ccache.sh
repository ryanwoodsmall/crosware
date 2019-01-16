rname="ccache"
rver="3.6"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://download.samba.org/pub/${rname}/${rfile}"
rsha256="a3f2b91a2353b65a863c5901251efe48060ecdebec46b5eaec8ea8e092b9e871"
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
