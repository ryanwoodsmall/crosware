rname="vim"
rver="8.0.1542"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/${rname}/${rname}/archive/${rfile}"
rsha256="d0818df5c6da23db725aa68067c90c80f0779c2e3446811bd1389b1ac2c2df86"
rreqs="make ncurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} --with-tlib=ncurses --without-local-dir --with-features=huge --without-x --enable-gui=no
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  # XXX - should prepend instead to prefer our vim?
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
