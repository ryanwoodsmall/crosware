#
# XXX - brotli 1.1.x apparently deprecates a standard Makefile for cmake/bazel/python? absolutely not.
# XXX - might just remove this. cmake. no. no no no no no no no no no
# XXX - the Makefile from 1.0.9 seems to work on 1.1.0. this becomes a liability. ugh.
#
rname="brotli"
rver="1.0.9"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/google/${rname}/archive/refs/tags/${rfile}"
rsha256="f9e8d81d0405ba66d181529af42a3354f838c939095ff99930da6aa9cdf6fe46"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make brotli lib CPPFLAGS= LDFLAGS=-static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  local l
  for l in common dec enc ; do
    ( cd bin/obj/c/\${l} ; \${AR} -v -r \"\$(cwbdir_${rname})/lib${rname}\${l}.a\" *.o )
  done
  cwmkdir \"\$(cwidir_${rname})/bin\"
  cwmkdir \"\$(cwidir_${rname})/lib/pkgconfig\"
  cwmkdir \"\$(cwidir_${rname})/include/${rname}\"
  \$(\${CC} -dumpmachine)-strip --strip-all bin/${rname}
  install -m 0755 bin/${rname} \"\$(cwidir_${rname})/bin/${rname}\"
  install -m 0644 lib*.a \"\$(cwidir_${rname})/lib/\"
  install -m 0644 c/include/${rname}/*.h \"\$(cwidir_${rname})/include/${rname}/\"
  for l in scripts/lib${rname}{common,dec,enc}*.pc.in ; do
    cat \${l} > \"\$(cwidir_${rname})/lib/pkgconfig/\$(basename \${l%%.in})\"
  done
  sed -i \"s,@prefix@,${rtdir}/current,g\" \$(cwidir_${rname})/lib/pkgconfig/*.pc
  sed -i \"s,@exec_prefix@,${rtdir}/current,g\" \$(cwidir_${rname})/lib/pkgconfig/*.pc
  sed -i \"s,@includedir@,${rtdir}/current/include,g\" \$(cwidir_${rname})/lib/pkgconfig/*.pc
  sed -i \"s,@libdir@,${rtdir}/current/lib,g\" \$(cwidir_${rname})/lib/pkgconfig/*.pc
  sed -i \"s,@PACKAGE_VERSION@,\$(cwver_${rname}),g\" \$(cwidir_${rname})/lib/pkgconfig/*.pc
  unset l
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
