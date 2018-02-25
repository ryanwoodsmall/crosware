rname="pkgconfig"
rver="0.29.2"
rdir="pkg-config-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://pkg-config.freedesktop.org/releases/${rfile}"
rsha256="6fc69c01688c9458a57eb9a1664c9aba372ccda420a02bf4429fe610e7e7d591"
rprof="${cwetcprofd}/${rname}.sh"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "                                                                                                                                                                                                 
function cwconfigure_${rname}() { 
  pushd "${cwbuild}/${rdir}" >/dev/null 2>&1 
  # sed -i.ORIG 's/-Werror=format=. //g' glib/configure
  ./configure --prefix="${cwsw}/${rname}/${rdir}" ${cwconfigurelibopts} --with-internal-glib
  popd >/dev/null 2>&1 
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path "${cwsw}/${rname}/current/bin"' > "${rprof}"
}
"
