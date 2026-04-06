rname="samurai"
rver="1.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/michaelforney/${rname}/releases/download/${rver}/${rfile}"
rsha256="1bc020a9e133432df51911ac71cc34322f828934d9a2282ba2916d88c15976af"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  sed -i.ORIG \"s,/usr/local,${ridir},g\" Makefile
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  make -j${cwmakejobs} ${rlibtool} LDFLAGS=-static CPPFLAGS=
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  make install ${rlibtool} LDFLAGS=-static CPPFLAGS=
  ln -sf samu \"${ridir}/bin/${rname}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
