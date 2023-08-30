#
# XXX - aarch64 only has SYS_getdents64, not SYS_getdents - introduced in 05a99f7d7f8e0999994b760bb6337ca10ea0a14b
# XXX - 9.4 includes openssl/configuration.h, which... ehh, just turn it off
#

rname="coreutils"
rver="9.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="ea613a4cf44612326e917201bbbcdfbd301de21ffc3b59b6e5c07e040b275e52"
rreqs="make gettexttiny sed attr acl perl gmp utillinux libcap"

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
    --with-openssl=no \
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
