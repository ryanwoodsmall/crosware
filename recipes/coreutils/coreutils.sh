#
# XXX - aarch64 only has SYS_getdents64, not SYS_getdents - introduced in 05a99f7d7f8e0999994b760bb6337ca10ea0a14b
#

rname="coreutils"
rver="9.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="6885ff47b9cdb211de47d368c17853f406daaf98b148aaecdf10de29cc04b0b3"
rreqs="make gettexttiny sed attr acl perl gmp openssl utillinux libcap"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env FORCE_UNSAFE_CONFIGURE=1 ./configure ${cwconfigureprefix} \
    --disable-nls \
    --enable-acl \
    --enable-libcap \
    --enable-single-binary=symlinks \
    --enable-xattr \
    --with-libgmp \
    --with-libgmp-prefix=\"${cwsw}/gmp/current\" \
    --with-openssl=yes \
    --without-selinux \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  uname -m | egrep -q '(aarch|riscv)64' && echo '#define SYS_getdents SYS_getdents64' >> src/ls.h || true
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
