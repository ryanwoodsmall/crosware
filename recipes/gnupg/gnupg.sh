#
# XXX - gnutls variant?
# XXX - netbsdcurses?
#

rname="gnupg"
rver="2.2.32"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://gnupg.org/ftp/gcrypt/${rname}/${rfile}"
rsha256="b2571b35f82c63e7d278aa6a1add0d73453dc14d3f0854be490c844fca7e0614"
rreqs="make libgpgerror libgcrypt libksba libassuan npth ntbtls sqlite readline ncurses slibtool zlib bzip2 pkgconfig pinentry configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=\"${cwsw}/libgpgerror/current/bin:${cwsw}/libgcrypt/current/bin:${cwsw}/libassuan/current/bin:${cwsw}/libksba/current/bin:${cwsw}/npth/current/bin:${cwsw}/ntbtls/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} \
      --disable-ccid-driver \
      --disable-dirmngr \
      --disable-gnutls \
      --disable-ldap \
      --disable-nls \
      --enable-ntbtls \
      --with-libgpg-error-prefix=\"${cwsw}/libgpgerror/current\" \
      --with-libgcrypt-prefix=\"${cwsw}/libgcrypt/current\" \
      --with-libassuan-prefix=\"${cwsw}/libassuan/current\" \
      --with-ksba-prefix=\"${cwsw}/libksba/current\" \
      --with-npth-prefix=\"${cwsw}/npth/current\" \
      --with-ntbtls-prefix=\"${cwsw}/ntbtls/current\" \
      --with-bzip2=\"${cwsw}/bzip2/current\" \
      --with-readline=\"${cwsw}/readline/current\" \
      --with-zlib=\"${cwsw}/zlib/current\" \
      --with-pinentry-pgm=\"${cwsw}/pinentry/current/bin/pinentry\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  local p
  for p in \$(find ${ridir}/bin/ ! -type d) ; do
    p=\$(basename \${p})
    ln -sf \${p} ${ridir}/bin/\${p}${rver%%.*}
  done
  unset p
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"
