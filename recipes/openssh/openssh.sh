#
# XXX - alpine patches: https://git.alpinelinux.org/aports/tree/main/openssh
# XXX - move config to $cwtop/etc/openssh
#

rname="openssh"
rver="8.1p1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/${rfile}"
rsha256="02f5dbef3835d0753556f973cd57b4c19b6b1f6cd24c03445e23ac77ca1b93ff"
rreqs="make zlib openssl netbsdcurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --without-pie \
    --with-libedit=\"${cwsw}/netbsdcurses/current\" \
    --sysconfdir=\"${rtdir}/etc\" \
      CPPFLAGS=\"-I${cwsw}/zlib/current/include -I${cwsw}/openssl/current/include -I${cwsw}/netbsdcurses/include\" \
      LDFLAGS=\"-static -L${cwsw}/zlib/current/lib -L${cwsw}/openssl/current/lib -L${cwsw}/netbsdcurses/current/lib\" \
      LIBS='-lcrypto -lz -lcrypt -ledit -lcurses -lterminfo'
  popd >/dev/null 2>&1
}
"

eval "
function cwuninstall_${rname}() {
  pushd \"${rtdir}\" >/dev/null 2>&1
  rm -rf ${rname}-* current previous
  rm -f \"${rprof}\"
  rm -f \"${cwvarinst}/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install
  install -m 0755 contrib/ssh-copy-id \"${ridir}/bin/\"
  for md in cat1 man1 ; do
    test -e \"${ridir}/share/man/\${md}\" \
    && install -m 0644 contrib/ssh-copy-id.1 \"${ridir}/share/man/\${md}/\" \
    || true
  done
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"
