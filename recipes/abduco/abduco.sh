rname="abduco"
rver="0.6"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/martanne/${rname}/releases/download/v${rver}/${rfile}"
rsha256="c90909e13fa95770b5afc3b59f311b3d3d2fdfae23f9569fa4f96a3e192a35f4"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  sed -i.ORIG '/^PREFIX/s,^PREFIX.*,PREFIX=${ridir},g' config.mk
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
