#
# XXX - aarch64 only has SYS_getdents64, not SYS_getdents - introduced in 05a99f7d7f8e0999994b760bb6337ca10ea0a14b
# XXX - 9.4 includes openssl/configuration.h, which... ehh, just turn it off
# XXX - 9.8 needs gmp > 6.2
#

rname="coreutils"
rver="9.7"
#rver="9.8"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/coreutils/${rfile}"
rsha256="0898a90191c828e337d5e4e4feb71f8ebb75aacac32c434daf5424cda16acb42"
#rsha256="1be88d53f694671cf7fb85e7723dbd1de9131d031880161b452a0685b986296e"
rreqs="make gettexttiny sed attr acl perl gmp utillinux libcap"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
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
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
