rname="slibtool"
rver="0.5.27"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/midipix-project/${rname}/archive/${rfile}"
rsha256="80d6db2bb6cd19bdcf6fdf76dd60061655431a24be0c37915f365b9120bac88c"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} --all-static
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
