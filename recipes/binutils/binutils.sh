#
# XXX - this needs custom ld.so stff just like statictoolchain built from musl-cross-make
# XXX - i.e., https://github.com/ryanwoodsmall/musl-misc/blob/master/musl-cross-make-confs/patches/9999-crosware-ldso_binutils-2.27.diff
#

rname="binutils"
rver="2.33.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="ab66fc2d1c3ec0359b8e08843c9f33b63e8707efdff5e4cc5c200eae24722cbf"
rreqs="make gmp mpfr mpc flex bison slibtool isl"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --enable-install-libiberty
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_cppflags \"-I${rtdir}/current/include\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
}
"
