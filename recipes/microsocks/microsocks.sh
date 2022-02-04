rname="microsocks"
rver="1.0.3"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/rofl0r/${rname}/archive/refs/tags/${rfile}"
rsha256="6801559b6f8e17240ed8eef17a36eea8643412b5a7476980fd4e24b02a021b82"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG 's,^prefix.*,prefix=${ridir},g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make CC=\"\${CC}\" CPPFLAGS= LDFLAGS=-static
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
