#
# XXX - uses separate openssldir in ${cwtop}/etc/libressl
# XXX - broken on centos 6, ugh
# XXX - 3.5.x breaks libssh2; see: https://github.com/libssh2/libssh2/pull/682
# XXX - need libressl33, libressl34, etc.?
# XXX - when upgraded, an installed dependents reinstall should be performed - {libssh2,curl,...}libressl
#
rname="libressl"
rver="3.7.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/${rfile}"
rurl="https://cdn.openbsd.org/pub/OpenBSD/LibreSSL/${rfile}"
rsha256="b06aa538fefc9c6b33c4db4931a09a5f52d9d2357219afcbff7d93fe12ebf6f7"
rreqs="bootstrapmake cacertificates configgit zlib"
# prefer openssl for now
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
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
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  rm -f \"\$(cwidir_${rname})/bin/openssl\" \"\$(cwidir_${rname})/bin/${rname}\"
  make install ${rlibtool}
  mv \"\$(cwidir_${rname})/bin/openssl\" \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/openssl\"
  ln -sf \"${rtdir}/current/bin/nc\" \"\$(cwidir_${rname})/bin/${rname}-nc\"
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
