#
# XXX - gnutls variant?
# XXX - netbsdcurses?
#

rname="gnupg"
rver="2.2.39"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://gnupg.org/ftp/gcrypt/${rname}/${rfile}"
rsha256="ab74db6685f026d7c0a10b527ecddecd608606a1691d15fda5d0a7f7d27e4c2f"
rreqs="make libgpgerror libgcrypt libksba libassuan npth ntbtls sqlite readline ncurses slibtool zlib bzip2 pkgconfig pinentry configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
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
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  local p
  for p in \$(find \$(cwidir_${rname})/bin/ ! -type d) ; do
    p=\$(basename \${p})
    ln -sf \${p} \$(cwidir_${rname})/bin/\${p}${rver%%.*}
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
