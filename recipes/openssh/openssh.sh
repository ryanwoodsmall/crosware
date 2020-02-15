#
# XXX - alpine patches: https://git.alpinelinux.org/aports/tree/main/openssh
# XXX - move config to $cwtop/etc/openssh
# XXX - libressl broken on centos 6, assume that kernel 2.x.x is cause?
# XXX - ugly ugly ugly
#

rname="openssh"
rver="8.2p1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/${rfile}"
rsha256="43925151e6cf6cee1450190c0e9af4dc36b41c12737619edff8bcebdff64e671"
rreqs="make zlib netbsdcurses"

# figure out which ssl provider to use
if $(uname -r | cut -f1 -d. | grep -q '^2$') ; then
  sslprov='openssl'
else
  sslprov='libressl'
fi
rreqs+=" ${sslprov}"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"${cwsw}/${sslprov}/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} \
      --without-pie \
      --with-libedit=\"${cwsw}/netbsdcurses/current\" \
      --sysconfdir=\"${rtdir}/etc\" \
        CPPFLAGS=\"-I${cwsw}/zlib/current/include -I${cwsw}/${sslprov}/current/include -I${cwsw}/netbsdcurses/include\" \
        LDFLAGS=\"-static -L${cwsw}/zlib/current/lib -L${cwsw}/${sslprov}/current/lib -L${cwsw}/netbsdcurses/current/lib\" \
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
  env PATH=\"${cwsw}/${sslprov}/current/bin:\${PATH}\" make install
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

unset sslprov
