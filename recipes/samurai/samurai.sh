rname="samurai"
rver="1.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/michaelforney/${rname}/releases/download/${rver}/${rfile}"
rsha256="3b8cf51548dfc49b7efe035e191ff5e1963ebc4fe8f6064a5eefc5343eaf78a5"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG \"s,/usr/local,${ridir},g\" Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} ${rlibtool} LDFLAGS=-static CPPFLAGS=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool} LDFLAGS=-static CPPFLAGS=
  ln -sf samu \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
