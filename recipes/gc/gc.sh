#
# XXX - works fine on x86_64, aarch64; not so much on armv7l, gc segfault
#       https://github.com/ivmai/bdwgc/blob/master/doc/README.environment
#       https://github.com/ivmai/bdwgc/blob/master/doc/README.macros
#       GC_INITIAL_HEAP_SIZE=... to 1MB+
#       default is 64k
#       GC_DONT_GC turns off collection, and works, but seems like a bad idea
#
# XXX - known issue on musl w/static linking (alpine)
#       https://github.com/ivmai/bdwgc/issues/154
#
# XXX - other opts
#       -DUSE_GET_STACKBASE_FOR_MAIN (https://bugzilla.redhat.com/show_bug.cgi?id=689877)
#       -DGC_DISABLE_INCREMENTAL
#       -DHBLKSIZE=#####
#
# XXX - shared (ONLY) build configure option changes
#   --enable-shared{,=yes} \
#   --enable-static=no \
#   --disable-static \
#   --disable-cplusplus \
#     CFLAGS=\"\${CFLAGS//-Wl,-static/} -D_GNU_SOURCE -DNO_GETCONTEXT -DUSE_MMAP -DHAVE_DL_ITERATE_PHDR -DIGNORE_DYNAMIC_LOADING\" \
#     CXXFLAGS=\"\${CXXFLAGS//-Wl,-static/} -D_GNU_SOURCE -DNO_GETCONTEXT -DUSE_MMAP -DHAVE_DL_ITERATE_PHDR -DIGNORE_DYNAMIC_LOADING\" \
#     LDFLAGS=\"\${LDFLAGS//-static/}\"
#
# XXX - riscv64 __data_start issue: https://github.com/ivmai/bdwgc/issues/294
#

rname="gc"
rver="8.0.6"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/ivmai/bdwgc/releases/download/v${rver}/${rfile}"
rsha256="3b4914abc9fa76593596773e4da671d7ed4d5390e3d46fbf2e5f155e121bea11"
rreqs="make libatomicops pkgconfig configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-cplusplus \
    --enable-large-config \
    --with-pic \
      CFLAGS=\"\${CFLAGS} -D_GNU_SOURCE -DNO_GETCONTEXT -DUSE_MMAP -DHAVE_DL_ITERATE_PHDR\" \
      CXXFLAGS=\"\${CXXFLAGS} -D_GNU_SOURCE -DNO_GETCONTEXT -DUSE_MMAP -DHAVE_DL_ITERATE_PHDR\"
  sed -i.ORIG 's|#include <unistd.h>|\\
#include <unistd.h>\\
#include <sys/select.h>|g' pthread_stop_world.c
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_cppflags \"-I${rtdir}/current/include\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
