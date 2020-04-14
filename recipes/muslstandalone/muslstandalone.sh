rname="muslstandalone"
rver="1.2.0"
rdir="musl-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://musl.libc.org/releases/${rfile}"
rsha256="c6de7b191139142d3f9a7b5b702c9cae1b5ee6e7f57e582da9328629408fd4e8"
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
  ./configure ${cwconfigureprefix} \
    --enable-debug \
    --enable-warnings \
    --enable-wrapper=all \
    --enable-shared \
    --enable-static \
      CFLAGS= \
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
  unset a
  ln -sf musl-gcc \"${ridir}/bin/cc\"
  ln -sf musl-gcc \"${ridir}/bin/gcc\"
  ln -sf musl-gcc \"${ridir}/bin/musl-cc\"
  ln -sf musl-gcc \"${ridir}/bin/${statictoolchain_triplet[${karch}]}-cc\"
  ln -sf musl-gcc \"${ridir}/bin/${statictoolchain_triplet[${karch}]}-gcc\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/ccache/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
