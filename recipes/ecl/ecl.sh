rname="ecl"
rver="16.1.3"
rdir="${rname}-${rver}"
rfile="${rname}-${rver}.tgz"
rurl="https://common-lisp.net/project/${rname}/static/files/release/${rfile}"
rsha256="76a585c616e8fa83a6b7209325a309da5bc0ca68e0658f396f49955638111254"
rreqs="make"

. "${cwrecipe}/common.sh"

if [[ ${uarch} =~ ^armv ]] ; then
eval "
function cwinstall_${rname}() {
  cwscriptecho \"recipe ${rname} does not support architecture ${uarch}\"
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
