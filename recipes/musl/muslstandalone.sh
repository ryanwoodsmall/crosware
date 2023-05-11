#
# XXX - symlink libraries may not be a great idea, append to .specs instead?
#   -L/usr/local/crosware/software/statictoolchain/current/lib/$(${CC} -dumpmachine)/lib
#
rname="muslstandalone"
rver="1.2.4"
rdir="musl-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://musl.libc.org/releases/${rfile}"
rsha256="7a35eae33d5372a7c0da1188de798726f68825513b7ae3ebe97aaaa52114f039"
rreqs="make"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\$(cwsha256_${rname})\"
  cwfetch_kernelheaders
}
"

eval "
function cwextract_${rname}() {
  cwextract \"\$(cwdlfile_${rname})\" \"${cwbuild}\"
  cwextract \$(cwdlfile_kernelheaders) \"\$(cwbdir_${rname})\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG 's#\\\$ldso#${rtdir}/current/lib/ld.so#g' tools/musl-gcc.specs.sh
  ./configure ${cwconfigureprefix} \
    --syslibdir=\"\$(cwidir_${rname})/lib\" \
    --enable-debug \
    --enable-warnings \
    --enable-wrapper=gcc \
    --enable-shared \
    --enable-static \
      CFLAGS='-fPIC' \
      CPPFLAGS= \
      CXXFLAGS= \
      LDFLAGS=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  local a
  if [[ ${karch} =~ ^i ]] ; then
    a=x86
  elif [[ ${karch} =~ ^arm ]] ; then
    a=arm
  else
    a=${karch}
  fi
  make install
  cd \$(cwdir_kernelheaders)
  make ARCH=\${a} prefix=\"\$(cwidir_${rname})\" install
  ln -sf musl-gcc \"\$(cwidir_${rname})/bin/cc\"
  ln -sf musl-gcc \"\$(cwidir_${rname})/bin/gcc\"
  ln -sf musl-gcc \"\$(cwidir_${rname})/bin/musl-cc\"
  ln -sf musl-gcc \"\$(cwidir_${rname})/bin/${statictoolchain_triplet[${karch}]}-cc\"
  ln -sf musl-gcc \"\$(cwidir_${rname})/bin/${statictoolchain_triplet[${karch}]}-gcc\"
  ln -sf libc.so \"\$(cwidir_${rname})/lib/ldd\"
  ln -sf \"${rtdir}/current/lib/ldd\" \"\$(cwidir_${rname})/bin/musl-ldd\"
  ln -sf libc.so \"\$(cwidir_${rname})/lib/ld.so\"
  sed -i.ORIG \"s#\$(cwidir_${rname})#${rtdir}/current#g\" \"\$(cwidir_${rname})/lib/musl-gcc.specs\"
  for a in \$(find \"${cwsw}/statictoolchain/current/\$(\${CC} -dumpmachine)/lib/\" -mindepth 1 -maxdepth 1 | grep '\\.a\$') ; do
    test -e \"\$(cwidir_${rname})/lib/\$(basename \${a})\" || ln -s \"\${a}\" \"\$(cwidir_${rname})/lib/\" || true
  done
  unset a
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${cwsw}/ccache/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
  echo export REALGCC=\"${cwsw}/statictoolchain/current/bin/\$(\${CC} -dumpmachine)-gcc\" >> \"${rprof}\"
}
"
