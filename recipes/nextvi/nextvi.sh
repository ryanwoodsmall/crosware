#
# XXX - standalone 5.3 patch2vi issu with itoa()?
#  ${cwsw}/statictoolchain/current/bin/../lib/gcc/x86_64-linux-musl/9.4.0/../../../../x86_64-linux-musl/bin/ld: /tmp/ccFEkBGe.o:
#    in function `itoalen':
#  patch2vi.c:(.text+0x3e): undefined reference to `itoa'
#
# XXX - splits.c fails, not sure why
#
rname="nextvi"
rver="7.3"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/kyx0r/nextvi/archive/refs/tags/${rfile}"
rsha256="0211704b11809b09cb737038a78b1fa637362a402da8f9e7879554496eb585de"
rreqs="bootstrapmake muslstandalone"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    export PATH=\"\$(echo ${cwsw}/{ccache{4,},muslstandalone,statictoolchain}/current/bin | tr ' ' ':'):\${PATH}\"
    export CC=musl-gcc
    bash ./cbuild.sh
    mv vi nextvi.temp
    make clean
    local ev=0
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
      linewrap_v1.sh \
      ex-scripting.sh \
      visual.sh \
      alt_sections.sh
    do
      cwscriptecho \"${rname}: applying patch \${p}\"
      export VI=\"\$(cwbdir_${rname})/nextvi.temp\"
      bash \"\${p}\"
      export ev=\"\${?}\"
      cwscriptecho \"${rname}: patch exit code was \${ev}\"
      test \"\${ev}\" -eq 0 || break
    done
    if [[ \"\${ev}\" -ne 0 ]] ; then
      cwfailexit \"failed with exit code \${ev}\"
    fi
    unset p
    unset ev
  )
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    export PATH=\"\$(echo ${cwsw}/{ccache{4,},muslstandalone,statictoolchain}/current/bin | tr ' ' ':'):\${PATH}\"
    export CC=musl-gcc
    bash ./cbuild.sh
    : \${CC} \${CFLAGS} patch2vi.c -o patch2vi -static
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \$(cwidir_${rname})/{bin,share/man/man1,libexec}
  rm -f \"\$(cwidir_${rname})/bin/${rname}\"
  install -m 0755 vi \"\$(cwidir_${rname})/bin/${rname}\"
  install -m 0644 vi.1 \"\$(cwidir_${rname})/share/man/man1/${rname}.1\"
  : strip --strip-all vi patch2vi
  : install -m 0755 patch2vi \"\$(cwidir_${rname})/libexec/\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
