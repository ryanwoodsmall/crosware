rname="libgpgerror"
rver="1.49"
rdir="libgpg-error-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://gnupg.org/ftp/gcrypt/libgpg-error/${rfile}"
rsha256="8b79d54639dbf4abc08b5406fb2f37e669a2dec091dd024fb87dd367131c63a9"
rreqs="make slibtool busybox"

. "${cwrecipe}/common.sh"

# XXX - https://git.alpinelinux.org/cgit/aports/tree/main/libgpg-error/fix-va_list.patch

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG '/_gpgrt_logv_printhex.*NULL,.*NULL/ s/NULL,.*NULL/NULL, arg_ptr/g' src/logging.c
  #sed -i 's/va_list arg_ptr;/va_list arg_ptr = {};/g' src/logging.c
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-nls \
    --enable-install-gpg-error-config \
      AWK='${cwsw}/busybox/current/bin/busybox awk' \
      LDFLAGS=-static \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
