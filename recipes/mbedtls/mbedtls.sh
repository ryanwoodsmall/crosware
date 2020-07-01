#
# XXX - need to require and enable zlib? probably not? deprecated?
# XXX - 2.23.x lts needs some changes to _not_ require python3...
#  cat programs/Makefile > programs/Makefile.ORIG
#  sed -i '/^\\tpsa\\/key_ladder_demo.*\\$/d' programs/Makefile
#  sed -i '/^\\tpsa\\/psa_constant_name.*\\$/d' programs/Makefile
#

rname="mbedtls"
rver="2.16.6"
rdir="${rname}-${rname}-${rver}"
rfile="${rname}-${rver}.tar.gz"
rurl="https://github.com/ARMmbed/${rname}/archive/${rfile}"
rsha256="38ea2768669d04dab7fe7d1114e489378bf4f23e5b96271a3ed4cecd99a3f807"
rreqs="make cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG \"s#^DESTDIR=.*#DESTDIR=${ridir}#g\" Makefile
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
