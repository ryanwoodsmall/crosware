#
# XXX - this needs custom ld.so stff just like statictoolchain built from musl-cross-make
# XXX - i.e., https://github.com/ryanwoodsmall/musl-misc/blob/master/musl-cross-make-confs/patches/9999-crosware-ldso_binutils-2.27.diff
#

rname="binutils"
rver="2.27"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="369737ce51587f92466041a97ab7d2358c6d9e1b6490b3940eb09fb0a9a6ac88"
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
