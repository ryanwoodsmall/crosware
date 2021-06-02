rname="tinyssh"
rver="20210601"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/janmojzis/${rname}/archive/refs/tags/${rfile}"
rsha256="2a051437878998c7782d9d38ef13e5e7a76435ae6b9c3e9ec492c3a567bd6314"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

# XXX - channel tests (at least) break on riscv64...
if [[ ${karch} =~ ^riscv64 ]] ; then
eval "
function cwinstall_${rname}() {
  cwscriptecho \"recipe ${rname} does not support architecture ${karch}\"
}
"
fi

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  echo '${ridir}/sbin' > conf-bin
  echo '${ridir}/share/man' > conf-man
  echo \"\${AR}\" > conf-ar
  echo \"\${CC}\" > conf-cc
  echo '-Wl,-static' >> conf-cflags
  echo '-static' >> conf-libs
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make CFLAGS= CPPFLAGS= CXXFLAGS= LDFLAGS= PKG_CONFIG_LIBDIR= PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
