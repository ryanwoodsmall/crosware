#
# XXX - needs a "--program-prefix=g" and symlinks setup similar to grep/sed
#     - or symlinks from non-prefix to prefix executables, like make
#     - gnudiff symlink too
#

rname="diffutils"
rver="3.10"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="90e5e93cc724e4ebe12ede80df1634063c7a855692685919bfe60b556c9bd09e"
rreqs="make sed gettexttiny"

. "${cwrecipe}/common.sh"

# XXX - sed fix from https://git.alpinelinux.org/cgit/aports/tree/main/diffutils/APKBUILD
eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG '/gets is a/d' lib/stdio.in.h
  ./configure ${cwconfigureprefix} --disable-nls
  cat lib/sigsegv.c > lib/sigsegv.c.ORIG
  echo '#include <config.h>' > lib/sigsegv.c
  echo '#include <sys/reg.h>' >> lib/sigsegv.c
  cat lib/sigsegv.c.ORIG >> lib/sigsegv.c
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
