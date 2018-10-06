#
# XXX - needs a "--program-prefix=g" and symlinks setup similar to grep/sed
#     - or symlinks from non-prefix to prefix executables, like make
#     - gnudiff symlink too
#

rname="diffutils"
rver="3.6"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="d621e8bdd4b573918c8145f7ae61817d1be9deb4c8d2328a65cea8e11d783bd6"
rreqs="make sed gettexttiny"

. "${cwrecipe}/common.sh"

# XXX - sed fix from https://git.alpinelinux.org/cgit/aports/tree/main/diffutils/APKBUILD
eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG '/gets is a/d' lib/stdio.in.h
  ./configure ${cwconfigureprefix} --disable-nls
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
