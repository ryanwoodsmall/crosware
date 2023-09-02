#
# XXX - brotli 1.1.x apparently deprecates a standard Makefile for cmake/bazel/python? absolutely not.
# XXX - might just remove this. cmake. no. no no no no no no no no no
# XXX - the Makefile from 1.0.9 seems to work on 1.1.0. this becomes a liability. ugh.
# XXX - lighttpd and wget2 are the only recipes that have brotli enabled. probably not adding to curl, et al.
# XXX - if the Makefile ever breaks, it's curtains for this recipe.
#
rname="brotli"
rver="1.1.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/google/${rname}/archive/refs/tags/${rfile}"
rsha256="e720a6ca29428b803f4ad165371771f5398faba397edf6778837a18599ea13ff"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\$(cwsha256_${rname})\"
  cwfetchcheck \
    \"https://raw.githubusercontent.com/google/brotli/v1.0.9/Makefile\" \
    \"${cwdl}/${rname}/Makefile\" \
    \"7389edcd71c5bc450e192f6ed4bb07782b470c6f676da4d3418d3bc5a279a7ed\"
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  install -m 0644 \"${cwdl}/${rname}/Makefile\" Makefile
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
