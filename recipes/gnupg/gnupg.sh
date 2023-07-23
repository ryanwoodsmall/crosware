#
# XXX - gnutls variant?
# XXX - netbsdcurses?
#

rname="gnupg"
rver="2.4.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://gnupg.org/ftp/gcrypt/${rname}/${rfile}"
rsha256="a271ae6d732f6f4d80c258ad9ee88dd9c94c8fdc33c3e45328c4d7c126bd219d"
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
      --with-pinentry-pgm=\"${cwsw}/pinentry/current/bin/pinentry\" \
        CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
        PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
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
