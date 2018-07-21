rname="coreutils"
rver="8.30"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="e831b3a86091496cdba720411f9748de81507798f6130adeaef872d206e1b057"
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
