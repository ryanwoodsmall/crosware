#
# XXX - need to strip cpack/cmake/ctest in bin/?
# XXX - aarch32 flakiness w/o -static
#

rname="cmake"
rver="3.14.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/Kitware/CMake/releases/download/v${rver}/${rfile}"
rsha256="00b4dc9b0066079d10f16eed32ec592963a44e7967371d2f5077fd1670ff36d9"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./bootstrap \
    ${cwconfigureprefix} \
    --no-system-libs \
    --parallel=${cwmakejobs} \
      CFLAGS=\"\${CFLAGS} -static\" \
      CXXFLAGS=\"\${CXXFLAGS} -static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
