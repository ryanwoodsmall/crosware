#
# XXX - no riscv64 support yet due to gc
#
rname="ecl"
rver="24.5.10"
rdir="${rname}-${rver}"
rfile="${rname}-${rver}.tgz"
rurl="https://common-lisp.net/project/${rname}/static/files/release/${rfile}"
rsha256="e4ea65bb1861e0e495386bfa8bc673bd014e96d3cf9d91e9038f91435cbe622b"
rreqs="make"

. "${cwrecipe}/common.sh"

if [[ ${karch} =~ ^(armv|riscv64) ]] ; then
  eval "function cwinstall_${rname}() { cwscriptecho \"recipe ${rname} does not support architecture ${karch}\" ; }"
fi

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
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
      LDFLAGS= \
      PKG_CONFIG_{PATH,LIBDIR}=
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
