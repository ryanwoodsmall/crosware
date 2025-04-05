rname="uredir"
rver="3.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/troglobit/${rname}/releases/download/v${rver}/${rfile}"
rsha256="1ce89747c963fdbf08e0a989d169980ec8732720b5c135c31e1743185abd92bb"
rreqs="make pkgconfig libuev libbsd"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  sed -i.ORIG s,sys/queue,bsd/sys/queue,g youdp.c
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts}
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  make install ${rlibtool}
  ln -sf \"${rname}\" \"${ridir}/bin/udpredir\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
