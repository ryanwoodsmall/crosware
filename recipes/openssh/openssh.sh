#
# XXX - alpine patches: https://git.alpinelinux.org/aports/tree/main/openssh
# XXX - move config to $cwtop/etc/openssh
# XXX - compilation w/libressl broken on centos 6, assume that kernel 2.x.x is cause?
# XXX - compilation w/libressl works on centos 7, kernel 3.10.x
# XXX - compilation w/libressl broken on chrome os w/kernel 3.8.x as well?
# XXX - ugly ugly ugly
# XXX - just go back to openssl for now
# XXX - revisit later?
#

rname="openssh"
rver="8.5p1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/${rfile}"
rsha256="f52f3f41d429aa9918e38cf200af225ccdd8e66f052da572870c89737646ec25"
rreqs="make zlib netbsdcurses groff"

## figure out which ssl provider to use
#if $(uname -r | cut -f1 -d. | grep -q '^2$') ; then
#  sslprov='openssl'
#else
#  sslprov='libressl'
#fi
sslprov=openssl
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
      --with-privsep-path=\"${cwtmp}/empty\" \
      --with-mantype=man \
        CPPFLAGS=\"-I${cwsw}/zlib/current/include -I${cwsw}/${sslprov}/current/include -I${cwsw}/netbsdcurses/include\" \
        LDFLAGS=\"-static -L${cwsw}/zlib/current/lib -L${cwsw}/${sslprov}/current/lib -L${cwsw}/netbsdcurses/current/lib\" \
        LIBS='-lcrypto -lz -lcrypt -ledit -lcurses -lterminfo'
  popd >/dev/null 2>&1
}
"

eval "
function cwuninstall_${rname}() {
  test -e \"${rtdir}\" || return
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
  local b
  local d
  local s
  env PATH=\"${cwsw}/${sslprov}/current/bin:\${PATH}\" make install
  install -m 0755 contrib/ssh-copy-id \"${ridir}/bin/\"
  for md in cat1 man1 ; do
    test -e \"${ridir}/share/man/\${md}\" \
    && install -m 0644 contrib/ssh-copy-id.1 \"${ridir}/share/man/\${md}/\" \
    || true
  done
  rm -f ${ridir}/*bin/${rname}{,-*} || true
  for s in \$(find ${ridir}/{,s}bin/ -mindepth 1 -maxdepth 1 ! -type d) ; do
    b=\"\$(basename \${s})\"
    d=\"\$(basename \$(dirname \${s}))\"
    ln -sf \"${rtdir}/current/\${d}/\${b}\" \"${ridir}/\${d}/${rname}-\${b}\"
  done
  ln -sf \"${rtdir}/current/bin/ssh\" \"${ridir}/bin/${rname}\"
  unset b
  unset d
  unset s
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
