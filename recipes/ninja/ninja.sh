rname="ninja"
rver="0ea27d728d34e3e2a1eae6f54dbe6ca0822a0b4a"
rdir="${rname}-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/${rname}-build/${rname}/archive/${rfile}"
rsha256="8058065a4d6443b3e037798e3feaadb06d2cbdb1585e0b07c00b268aa714b9c4"
rreqs="make python3"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  python3 ./configure.py --bootstrap
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  true
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  install -m 755 \"${rname}\" \"${ridir}/bin/\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
