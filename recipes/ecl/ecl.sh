#
# XXX - no riscv64 support yet due to gc
#

rname="ecl"
rver="20.4.24"
rdir="${rname}-${rver}"
rfile="${rname}-${rver}.tgz"
rurl="https://common-lisp.net/project/${rname}/static/files/release/${rfile}"
rsha256="670838edf258a936b522fdb620da336de7e575aa0d27e34841727252726d0f07"
rreqs="make"

. "${cwrecipe}/common.sh"

if [[ ${karch} =~ ^(armv|riscv64) ]] ; then
eval "
function cwinstall_${rname}() {
  cwscriptecho \"recipe ${rname} does not support architecture ${karch}\"
}
"
fi

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --enable-shared=yes \
    --enable-boehm=included \
    --enable-libatomic=included \
    --enable-gmp=portable \
    --with-dffi=included \
    --enable-manual=no \
    CFLAGS='-D_GNU_SOURCE -DNO_GETCONTEXT -DUSE_MMAP -DHAVE_DL_ITERATE_PHDR -fPIC' \
    CXXFLAGS='-D_GNU_SOURCE -DNO_GETCONTEXT -DUSE_MMAP -DHAVE_DL_ITERATE_PHDR -fPIC' \
    CPPFLAGS= \
    LDFLAGS=
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
