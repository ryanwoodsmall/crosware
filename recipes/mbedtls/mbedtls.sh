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
rreqs="make cacertificates"

. "${cwrecipe}/common.sh"

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
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
