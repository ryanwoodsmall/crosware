#
# XXX - symlink libraries may not be a great idea, append to .specs instead?
#   -L/usr/local/crosware/software/statictoolchain/current/lib/$(${CC} -dumpmachine)/lib
#
rname="muslstandalone"
rver="1.2.1"
rdir="musl-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://musl.libc.org/releases/${rfile}"
rsha256="68af6e18539f646f9c41a3a2bb25be4a5cfa5a8f65f0bb647fd2bbfdf877e84b"
rreqs="make"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  cwfetch_kernelheaders
}
"

eval "
function cwextract_${rname}() {
  cwextract \"${rdlfile}\" \"${cwbuild}\"
  cwextract \$(cwdlfile_kernelheaders) \"${rbdir}\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG 's#\\\$ldso#${rtdir}/current/lib/ld.so#g' tools/musl-gcc.specs.sh
  ./configure ${cwconfigureprefix} \
    --syslibdir=\"${ridir}/lib\" \
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
  pushd \"${rbdir}\" >/dev/null 2>&1
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
  make ARCH=\${a} prefix=\"${ridir}\" install
  ln -sf musl-gcc \"${ridir}/bin/cc\"
  ln -sf musl-gcc \"${ridir}/bin/gcc\"
  ln -sf musl-gcc \"${ridir}/bin/musl-cc\"
  ln -sf musl-gcc \"${ridir}/bin/${statictoolchain_triplet[${karch}]}-cc\"
  ln -sf musl-gcc \"${ridir}/bin/${statictoolchain_triplet[${karch}]}-gcc\"
  ln -sf libc.so \"${ridir}/lib/ldd\"
  ln -sf \"${rtdir}/current/lib/ldd\" \"${ridir}/bin/musl-ldd\"
  ln -sf libc.so \"${ridir}/lib/ld.so\"
  sed -i.ORIG 's#${ridir}#${rtdir}/current#g' \"${ridir}/lib/musl-gcc.specs\"
  for a in \$(find \"${cwsw}/statictoolchain/current/\$(\${CC} -dumpmachine)/lib/\" -mindepth 1 -maxdepth 1 | grep '\\.a\$') ; do
    test -e \"${ridir}/lib/\$(basename \${a})\" || ln -s \"\${a}\" \"${ridir}/lib/\" || true
  done
  unset a
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${cwsw}/ccache/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
  echo 'export REALGCC=\"${cwsw}/statictoolchain/current/bin/\${CC}\"' >> \"${rprof}\"
}
"
