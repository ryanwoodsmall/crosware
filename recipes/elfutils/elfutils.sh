#
# XXX - use m4 from otools instead of bringing in m4+make+sed+gawk+busybox+toybox...
# XXX - baseutils has an m4 as well, bmake is only req
#
rname="elfutils"
rver="0.192"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://sourceware.org/elfutils/ftp/${rver}/${rfile}"
rsha256="616099beae24aba11f9b63d86ca6cc8d566d968b802391334c91df54eab416b4"
rreqs="bootstrapmake zlib libuargp muslfts muslobstack otools"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --disable-debuginfod \
    --disable-libdebuginfod \
    --disable-nls \
    --enable-deterministic-archives \
    --enable-install-elfh \
    --program-prefix=eu- \
    --without-biarch \
      C{,XX}FLAGS='-fPIC -Wno-error=unused-parameter -Os -g0 -Wl,-s' \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -s\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      LIBS=\"-largp -lfts -lz -s\"
  echo '#undef FNM_EXTMATCH' >> config.h
  echo '#define FNM_EXTMATCH 0' >> config.h
  sed -i.ORIG 's,-lobstack,-lobstack -largp -lfts,g' libdw/Makefile
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool}
  (
    cd src
    make clean
    cat Makefile > Makefile.ORIG
    sed -i 's,\\.so,.a,g' Makefile
    sed -i 's,-shared,,g' Makefile
    sed -i '/^libdw/d' Makefile
    sed -i '/^#libdw/s,^#,,g' Makefile
    sed -i '/^srcfiles_LDADD/s,\$, -static,' Makefile
    sed -i '/^.*_LDADD = /s,(libelf) ,(libelf) -largp -lz ,g' Makefile
    sed -i '/^.*_LDADD = /s,(libdw) ,(libdw) -lfts ,g' Makefile
    make ${rlibtool} CC=\"\${CC} -Wl,-static -Wl,-largp -Wl,-lfts -Wl,-lz\"
    make install ${rlibtool}
  )
  rm -f \$(cwidir_${rname})/lib/lib*.so*
  rm -f \$(cwidir_${rname})/include/${rname}_elf.h
  cat \$(cwidir_${rname})/include/elf.h > \$(cwidir_${rname})/include/${rname}_elf.h
  rm -f \$(cwidir_${rname})/include/elf.h
  sed -i 's,-ldw,-ldw -lfts,g' \$(cwidir_${rname})/lib/pkgconfig/libdw.pc
  sed -i 's,-lelf,-lelf -lz,g' \$(cwidir_${rname})/lib/pkgconfig/libelf.pc
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
