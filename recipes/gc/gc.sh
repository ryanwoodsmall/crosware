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

rname="gc"
rver="7.6.10"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/ivmai/bdwgc/releases/download/v${rver}/${rfile}"
rsha256="4fc766749a974700c576bbfb71b4a73b2ed746082e2fc8388bfb0b54b636af14"
rreqs="make libatomicops pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --enable-cplusplus \
    --enable-large-config \
    --with-pic \
      CFLAGS=\"\${CFLAGS} -D_GNU_SOURCE -DNO_GETCONTEXT -DUSE_MMAP -DHAVE_DL_ITERATE_PHDR -DIGNORE_DYNAMIC_LOADING\" \
      CXXFLAGS=\"\${CXXFLAGS} -D_GNU_SOURCE -DNO_GETCONTEXT -DUSE_MMAP -DHAVE_DL_ITERATE_PHDR -DIGNORE_DYNAMIC_LOADING\"
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
