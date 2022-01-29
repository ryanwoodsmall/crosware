rname="libgpgerror"
rver="1.44"
rdir="libgpg-error-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://gnupg.org/ftp/gcrypt/libgpg-error/${rfile}"
rsha256="8e3d2da7a8b9a104dd8e9212ebe8e0daf86aa838cc1314ba6bc4de8f2d8a1ff9"
rreqs="make slibtool busybox"

. "${cwrecipe}/common.sh"

# XXX - https://git.alpinelinux.org/cgit/aports/tree/main/libgpg-error/fix-va_list.patch

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG '/_gpgrt_logv_printhex.*NULL,.*NULL/ s/NULL,.*NULL/NULL, arg_ptr/g' src/logging.c
  #sed -i 's/va_list arg_ptr;/va_list arg_ptr = {};/g' src/logging.c
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --disable-nls AWK='busybox awk'
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
