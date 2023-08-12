#
# XXX - distribute an autotools-ed version of the archive?
# XXX - no, just avoid it entirely
#
rname="muslfts"
rver="1.2.7"
rdir="musl-fts-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/pullmoll/musl-fts/archive/${rfile}"
rsha256="49ae567a96dbab22823d045ffebe0d6b14b9b799925e9ca9274d47d26ff482a6"
rreqs=""

. "${cwrecipe}/common.sh"

cwstubfunc "cwmake_${rname}"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  local h
  for h in ASSERT DIRENT DLFCN ERRNO FCNTL INTTYPES STDINT STDIO STDLIB STRINGS STRING SYS_PARAM SYS_STAT SYS_TYPES UNISTD ; do
    echo \"#define HAVE_\${h}_H 1\"
  done > config.h
  echo '#define HAVE_DECL_MAX 1' >> config.h
  echo '#define HAVE_DECL_UINTMAX_MAX 0' >> config.h
  echo '#define HAVE_DIRFD 1' >> config.h
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  \${CC} -I. -fPIC -c fts.c -o fts.o
  \${AR} -v -r libfts.a fts.o
  cat > musl-fts.pc << EOF
prefix=${rtdir}/current
exec_prefix=${rtdir}/current
libdir=${rtdir}/current/lib
includedir=${rtdir}/current/include

Name: musl-fts
Description: Implementation of fts(3) functions for musl libc
Version: \$(cwver_${rname})
Libs: -L${rtdir}/current/lib -lfts
Cflags: -I${rtdir}/current/include
EOF
  cwmkdir \$(cwidir_${rname})/include
  cwmkdir \$(cwidir_${rname})/lib/pkgconfig
  cwmkdir \$(cwidir_${rname})/share/man/man3
  install -m 644 fts.3 \$(cwidir_${rname})/share/man/man3/
  install -m 644 fts.h \$(cwidir_${rname})/include/
  install -m 644 libfts.a \$(cwidir_${rname})/lib/
  install -m 644 musl-fts.pc \$(cwidir_${rname})/lib/pkgconfig/
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
