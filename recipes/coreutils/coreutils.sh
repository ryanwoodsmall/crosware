rname="coreutils"
rver="8.31"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="ff7a9c918edce6b4f4b2725e3f9b37b0c4d193531cac49a48b56c4d0d3a9e9fd"
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
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
