#
# XXX - aarch64 only has SYS_getdents64, not SYS_getdents - introduced in 05a99f7d7f8e0999994b760bb6337ca10ea0a14b
#

rname="coreutils"
rver="9.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="ce30acdf4a41bc5bb30dd955e9eaa75fa216b4e3deb08889ed32433c7b3b97ce"
rreqs="make gettexttiny sed attr acl perl"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG s/stdbuf_supported=yes/stdbuf_supported=no/g configure
  env FORCE_UNSAFE_CONFIGURE=1 ./configure ${cwconfigureprefix} \
    --disable-libcap \
    --disable-nls \
    --enable-acl \
    --enable-single-binary=symlinks \
    --enable-xattr \
    --without-libgmp \
    --without-openssl \
    --without-selinux \
      CPPFLAGS='-I${cwsw}/acl/current/include -I${cwsw}/attr/current/include' \
      LDFLAGS='-L${cwsw}/acl/current/lib -L${cwsw}/attr/current/lib -static'
  uname -m | egrep -q '(aarch|riscv)64' && echo '#define SYS_getdents SYS_getdents64' >> src/ls.h || true
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
