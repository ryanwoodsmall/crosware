rname="nextvi"
rver="4.2"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/kyx0r/nextvi/archive/refs/tags/${rfile}"
rsha256="eab8fe6432408c16b339392420ba1b480e8f9e7a000f4fcb9b18cc3ec3dc72b3"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  bash ./cbuild.sh
  mv vi nextvi.temp
  make clean
  local p
  for p in \
    arrowkeys_normal.sh \
    arrowkeys_insert.sh \
    stdin_pipe.sh \
    filetype_shebang.sh \
    c_option.sh \
    readonly.sh \
    alternate-w-behaviour.sh \
    ac_context.sh \
    linewrap.sh \
    ex-scripting.sh \
    visual.sh \
    alt_sections.sh
  do
    cwscriptecho \"${rname}: applying patch \${p}\"
    (
      export VI=\"\$(cwbdir_${rname})/nextvi.temp\"
      bash \"\${p}\"
    )
  done
  unset p
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  bash ./cbuild.sh
  \${CC} \${CFLAGS} patch2vi.c -o patch2vi -static
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \$(cwidir_${rname})/{bin,share/man/man1,libexec}
  rm -f \"\$(cwidir_${rname})/bin/${rname}\"
  strip --strip-all vi patch2vi
  install -m 0755 vi \"\$(cwidir_${rname})/bin/${rname}\"
  install -m 0644 vi.1 \"\$(cwidir_${rname})/share/man/man1/${rname}.1\"
  install -m 0755 patch2vi \"\$(cwidir_${rname})/libexec/\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
