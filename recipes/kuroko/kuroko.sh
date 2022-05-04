#
# XXX - separate out static-only recipe?
#

rname="kuroko"
rver="1.2.5"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/${rname}-lang/${rname}/archive/refs/tags/${rfile}"
rsha256="fa068e5a12c5153e1fc4c667f5efb83651c7b491c804870bb873c65c484e6e0a"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwpatch_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG \"s,/usr/local,${ridir},g\" Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env CPPFLAGS= LDFLAGS= CFLAGS='-Wl,-rpath,${rtdir}/current/lib -fPIC' make
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install-strip ${rlibtool}
  cwmakeinstall_${rname}_static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}_static() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make clean
  cat Makefile.ORIG > Makefile
  sed -i.ORIG \"s,/usr/local,${ridir}/static,g\" Makefile
  env CPPFLAGS= LDFLAGS=-static CFLAGS=\"\${CFLAGS} -static\" CC=\"\${CC} -DSTATIC_ONLY\" make
  make install-strip ${rlibtool}
  popd >/dev/null 2>&1
}
"
