rname="coreutils"
rver="8.29"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="92d0fa1c311cacefa89853bdb53c62f4110cdfda3820346b59cbd098f40f955e"
rreqs="make gettexttiny"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG s/stdbuf_supported=yes/stdbuf_supported=no/g configure
  ./configure ${cwconfigureprefix} \
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
