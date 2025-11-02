#
# XXX - works fine on x86_64, aarch64; not so much on armv7l, gc segfault
#       https://github.com/ivmai/bdwgc/blob/master/doc/README.environment
#       https://github.com/ivmai/bdwgc/blob/master/doc/README.macros
#       GC_INITIAL_HEAP_SIZE=... to 1MB+
#       default is 64k
#       GC_DONT_GC turns off collection, and works, but seems like a bad idea
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
rname="gc"
rver="8.2.10"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/ivmai/bdwgc/releases/download/v${rver}/${rfile}"
rsha256="832cf4f7cf676b59582ed3b1bbd90a8d0e0ddbc3b11cb3b2096c5177ce39cc47"
rreqs="make libatomicops pkgconfig configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-cplusplus \
    --enable-large-config \
    --with-pic \
      CFLAGS=\"\${CFLAGS} -D_GNU_SOURCE -DNO_GETCONTEXT -DUSE_MMAP -DHAVE_DL_ITERATE_PHDR\" \
      CXXFLAGS=\"\${CXXFLAGS} -D_GNU_SOURCE -DNO_GETCONTEXT -DUSE_MMAP -DHAVE_DL_ITERATE_PHDR\"
  sed -i.ORIG 's|#include <unistd.h>|\\
#include <unistd.h>\\
#include <sys/select.h>|g' pthread_stop_world.c
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_cppflags \"-I${rtdir}/current/include\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
