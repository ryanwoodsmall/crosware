#
# XXX - need to require and enable zlib? probably not? deprecated?
# XXX - alpine still tracking 2.16.x, maybe stick with that
# XXX - 2.23.x lts needs some changes to _not_ require python3...
#  cat programs/Makefile > programs/Makefile.ORIG
#  sed -i '/^\\tpsa\\/key_ladder_demo.*\\$/d' programs/Makefile
#  sed -i '/^\\tpsa\\/psa_constant_name.*\\$/d' programs/Makefile
# XXX - is threading right?
#  see alpine: https://git.alpinelinux.org/aports/tree/main/mbedtls/APKBUILD
#

rname="mbedtls"
rver="2.16.10"
rdir="${rname}-${rname}-${rver}"
rfile="${rname}-${rver}.tar.gz"
rurl="https://github.com/ARMmbed/${rname}/archive/${rfile}"
rsha256="78c02e2d277a302454ada90274d16d80f88d761bdd4243528e4206cf7920be78"
rreqs="make cacertificates zlib"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  cwfetch_libssh2
}
"

eval "
function cwextract_${rname}() {
  cwextract \"${rdlfile}\" \"${cwbuild}\"
  cwextract \"\$(cwdlfile_libssh2)\" \"${rbdir}\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG \"s#^DESTDIR=.*#DESTDIR=${ridir}#g\" Makefile
  cat include/mbedtls/config.h > include/mbedtls/config.h.ORIG
  sed -i '/define MBEDTLS_THREADING_C/s,//,,g' include/mbedtls/config.h
  sed -i '/define MBEDTLS_THREADING_PTHREAD/s,//,,g' include/mbedtls/config.h
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} no_test CC=\"\${CC}\" CFLAGS=\"\${CFLAGS}\" LDFLAGS=\"-static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  echo cwmakeinstall_${rname}_libssh2
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}_libssh2() {
  pushd \"${rbdir}/\$(cwdir_libssh2)\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --with-crypto=mbedtls \
    --with-libmbedcrypto-prefix=\"${ridir}\" \
    --with-libz=\"${cwsw}/zlib/current\" \
      CPPFLAGS=\"-I${ridir}/include -I${cwsw}/zlib/current/include\" \
      LDFLAGS=\"-L${ridir}/lib -L${cwsw}/zlib/current/lib -static\"
  make -j${cwmakejobs} ${rlibtool}
  rm -f \"${ridir}/lib/libssh2-${rname}.a\"
  make install ${rlibtool}
  mv \"${ridir}/lib/libssh2.a\" \"${ridir}/lib/libssh2-${rname}.a\"
  sed '/^Name:/s/libssh2/libssh2-${rname}/g' \"${ridir}/lib/pkgconfig/libssh2.pc\" > \"${ridir}/lib/pkgconfig/libssh2-${rname}.pc\"
  rm -f \"${ridir}/lib/pkgconfig/libssh2.pc\"
  rm -f \"${ridir}/lib/libssh2.la\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
