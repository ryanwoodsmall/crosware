#
# XXX - uses separate openssldir in ${cwtop}/etc/libressl
# XXX - broken on centos 6, ugh
#
rname="libressl"
rver="3.4.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/${rfile}"
rsha256="cb82ca7d547336917352fbd23db2fc483c6c44d35157b32780214ec74197b3ce"
rreqs="make cacertificates configgit zlib"
# prefer openssl for now
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --disable-asm \
    --enable-nc \
    --with-openssldir=\"${cwetc}/${rname}\" \
    --with-pic \
      CC=\"\${CC} -Os\" \
      CFLAGS=\"-Os \${CFLAGS}\" \
      CPPFLAGS= \
      LDFLAGS=-static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  rm -f \"${ridir}/bin/openssl\" \"${ridir}/bin/${rname}\"
  make install ${rlibtool}
  mv \"${ridir}/bin/openssl\" \"${ridir}/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/bin/openssl\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/openssl/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"

#  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
#  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
#  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
