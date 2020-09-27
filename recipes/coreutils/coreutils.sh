#
# XXX - aarch64 only has SYS_getdents64, not SYS_getdents - introduced in 05a99f7d7f8e0999994b760bb6337ca10ea0a14b
#

rname="coreutils"
rver="8.32"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="4458d8de7849df44ccab15e16b1548b285224dbba5f08fac070c1c0e0bcc4cfa"
rreqs="make gettexttiny sed"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG s/stdbuf_supported=yes/stdbuf_supported=no/g configure
  env FORCE_UNSAFE_CONFIGURE=1 ./configure ${cwconfigureprefix} \
    --disable-acl \
    --disable-libcap \
    --disable-nls \
    --disable-xattr \
    --enable-single-binary=symlinks \
    --without-gmp \
    --without-openssl \
    --without-selinux \
      CPPFLAGS='' \
      LDFLAGS='-static'
  uname -m | egrep -q '(aarch|riscv)64' && echo '#define SYS_getdents SYS_getdents64' >> src/ls.h || true
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
