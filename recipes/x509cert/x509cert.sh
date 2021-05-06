rname="x509cert"
rver="64155493ee8c97eea89a92f53ce56e57ff0aeb46"
rdir="${rname}-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/michaelforney/${rname}/archive/${rfile}"
rsha256=""
rreqs="make bearssl"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetch \"${rurl}\" \"${rdlfile}\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG 's,^PREFIX=.*,PREFIX=${ridir},g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make \
    CC=\"\${CC} \${CFLAGS} -I${cwsw}/bearssl/current/include\" \
    LD{FLAGS,LIBS}=\"-L${cwsw}/bearssl/current/lib -lbearssl -static\" \
    CPPFLAGS= \
    PKG_CONFIG_LIBDIR= \
    PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  rm -f ${ridir}/include/*.{h,ORIG}
  make install
  \$(\${CC} -dumpmachine)-strip --strip-all \"${ridir}/bin/${rname}\"
  mv \"${ridir}/include/asn1.h\" \"${ridir}/include/${rname}_asn1.h\"
  sed -i '/^#include/s/asn1/${rname}_asn1/g' \"${ridir}/include/${rname}.h\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
}
"
