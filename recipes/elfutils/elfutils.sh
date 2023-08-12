#
# XXX - use m4 from otools instead of bringing in m4+make+sed+gawk+busybox+toybox...
# XXX - baseutils has an m4 as well, bmake is only req
#
rname="elfutils"
rver="0.189"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://sourceware.org/elfutils/ftp/${rver}/${rfile}"
rsha256="39bd8f1a338e2b7cd4abc3ff11a0eddc6e690f69578a57478d8179b4148708c8"
rreqs="bootstrapmake zlib libuargp muslfts muslobstack otools"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --disable-debuginfod \
    --disable-libdebuginfod \
    --disable-nls \
    --enable-install-elfh \
    --without-biarch \
      C{,XX}FLAGS=-fPIC \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib)\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      LIBS=\"-largp -lfts -lz\"
  echo '#undef FNM_EXTMATCH' >> config.h
  echo '#define FNM_EXTMATCH 0' >> config.h
  sed -i.ORIG 's,-lobstack,-lobstack -largp -lfts,g' libdw/Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  (
    cd src
    make clean
    cat Makefile > Makefile.ORIG
    sed -i 's,\\.so,.a,g' Makefile
    sed -i 's,-shared,,g' Makefile
    sed -i '/^libdw/d' Makefile
    sed -i '/^#libdw/s,^#,,g' Makefile
    make ${rlibtool} CC=\"\${CC} -Wl,-static\"
    make install ${rlibtool}
  )
  rm -f \$(cwidir_${rname})/lib/lib*.so*
  rm -f \$(cwidir_${rname})/include/${rname}_elf.h
  cat \$(cwidir_${rname})/include/elf.h > \$(cwidir_${rname})/include/${rname}_elf.h
  rm -f \$(cwidir_${rname})/include/elf.h
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
