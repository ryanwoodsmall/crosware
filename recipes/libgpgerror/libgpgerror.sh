rname="libgpgerror"
rver="1.28"
rdir="libgpg-error-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://gnupg.org/ftp/gcrypt/libgpg-error/${rfile}"
rsha256="3edb957744905412f30de3e25da18682cbe509541e18cd3b8f9df695a075da49"
rreqs="make"

. "${cwrecipe}/common.sh"

# XXX - https://git.alpinelinux.org/cgit/aports/tree/main/libgpg-error/fix-va_list.patch

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG '/_gpgrt_logv_printhex.*NULL,.*NULL/ s/NULL,.*NULL/NULL, arg_ptr/g' src/logging.c
  #sed -i 's/va_list arg_ptr;/va_list arg_ptr = {};/g' src/logging.c
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
