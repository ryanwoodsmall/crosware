#
# XXX - use m4 from otools instead of bringing in m4+make+sed+gawk+busybox+toybox...
# XXX - baseutils has an m4 as well, bmake is only req
# XXX - something changed with 0.195 (or zlib), zlib is now giving crc32 conflicts
#
rname="elfutils"
rver="0.195"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://sourceware.org/elfutils/ftp/${rver}/${rfile}"
rsha256="37629fdf7f1f3dc2818e138fca2b8094177d6c2d0f701d3bb650a561218dc026"
rreqs="bootstrapmake zlib libuargp muslfts muslobstack otools pkgconf"

. "${cwrecipe}/common.sh"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  grep -rl ' crc32 ' . | grep -E '\\.(c|h)\$' | xargs sed -i.ORIG 's, crc32 , eu_crc32 ,g'
  sed -i.ORIG 's,^crc32 ,eu_crc32 ,g' lib/crc32.c
  # find . -type f | grep ORIG$ ; exit 1
  popd &>/dev/null
}
"

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
      C{,XX}FLAGS='-fPIC -Wno-error=unused-parameter -Wno-error=unused-but-set-variable -Os -g0 -Wl,-s' \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -s\" \
      PKG_CONFIG=\"${cwsw}/pkgconf/current/bin/pkgconf\" \
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
