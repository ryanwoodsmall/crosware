#
# XXX - libaio, zlib, ...
# XXX - arm, riscv need libfdt; can't get aarch64 to compile though
# XXX - fork/branch?
#   - https://git.kernel.org/?q=kvmtool
#     - https://git.kernel.org/pub/scm/linux/kernel/git/maz/kvmtool.git/
#     - https://git.kernel.org/pub/scm/linux/kernel/git/oupton/kvmtool.git/
#     - https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/
#
rname="kvmtool"
rver="b48735e5d562eaffb96cf98a91da212176f1534c"
rdir="${rname}-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/kvmtool/kvmtool/archive/${rfile}"
rsha256="9055a23bdf066fadd48dfe25ed67ad8bd230a7b865b8b67782a8166d5bdd1451"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    unset CPPFLAGS PKG_CONFIG_{LIBDIR,PATH}
    export LDFLAGS=-static
    make LDFLAGS='-static' CC=\"\${CC} \${CFLAGS}\" V=0
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \$(cwidir_${rname})/bin
  cwmkdir \$(cwidir_${rname})/share/man/man1
  install -m 0755 lkvm \$(cwidir_${rname})/bin/${rname}
  install -m 0755 lkvm \$(cwidir_${rname})/bin/lkvm
  \${CC//gcc/strip} --strip-all \$(cwidir_${rname})/bin/lkvm
  install -m 0755 Documentation/${rname}.1 \$(cwidir_${rname})/share/man/man1/${rname}.1
  ln -sf ${rname}.1 \$(cwidir_${rname})/share/man/man1/lkvm.1
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
