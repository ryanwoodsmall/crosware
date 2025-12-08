#
# XXX - patches are included in the released .tar.gz at least as of 1.0
#
rname="nextvi"
rver="2.5"
rdir="${rname}-${rver}"
#rfile="${rver}.zip"
#rurl="https://github.com/kyx0r/nextvi/archive/${rfile}"
rfile="${rver}.tar.gz"
rurl="https://github.com/kyx0r/nextvi/archive/refs/tags/${rfile}"
rsha256="27e5a20f6d9c412f3c8bcb0850c57bee3bbd792885624d2022c14531318c13d2"
rreqs="patch"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  local p
  for p in arrowkeys_insert.patch arrowkeys_normal.patch filetype_shebang.patch stdin_pipe.patch c_option.patch ; do
    cwscriptecho \"${rname}: applying patch \${p}\"
    patch -p1 < \${p}
  done
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  bash ./cbuild.sh
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \$(cwidir_${rname})/{bin,share/man/man1}
  rm -f \"\$(cwidir_${rname})/bin/${rname}\"
  strip --strip-all vi
  install -m 0755 vi \"\$(cwidir_${rname})/bin/${rname}\"
  install -m 0644 vi.1 \"\$(cwidir_${rname})/share/man/man1/${rname}.1\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
