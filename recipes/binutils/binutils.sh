#
# XXX - this needs custom ld.so stff just like statictoolchain built from musl-cross-make
# XXX - i.e., https://github.com/ryanwoodsmall/musl-misc/blob/master/musl-cross-make-confs/patches/9999-crosware-ldso_binutils-2.27.diff
# XXX - 2.33.1 breakage compiling static on arm 32-bit ugh?
#

rname="binutils"
rver="2.33.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="ab66fc2d1c3ec0359b8e08843c9f33b63e8707efdff5e4cc5c200eae24722cbf"
rreqs="make gmp mpfr mpc flex bison slibtool isl zlib gawk"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-nls \
    --with-system-zlib \
    --with-static-standard-libraries \
    --with-pic \
    --with-mmap \
    --disable-lto \
    --disable-multilib \
    --disable-host-shared \
    --enable-install-libiberty \
      CC=\"\${CC} -static --static\" \
      CXX=\"\${CXX} -static --static\"
    #--with-{boot,stage1}-ldflags=\"\${LDFLAGS}\" \
    #--with-{boot,stage1}-libs=\"-static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_cppflags \"-I${rtdir}/current/include\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
}
"
