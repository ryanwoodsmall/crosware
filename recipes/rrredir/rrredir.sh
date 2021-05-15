rname="rrredir"
rver="0ce7d3aff21243807f618fadabd5ef2e2fc74db9"
rdir="${rname}-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/rofl0r/${rname}/archive/${rfile}"
rsha256=""
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetch \"${rurl}\" \"${rdlfile}\"
}
"

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
