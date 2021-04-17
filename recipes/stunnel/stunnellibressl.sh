#
# XXX - older version
# XXX - lots of changes drift between openssl and libressl
# XXX - no up-to-date patches
#

rname="stunnellibressl"
rver="5.51"
rdir="${rname%libressl}-${rver}"
rfile="${rdir}.tar.gz"
rdlfile="${cwdl}/${rname%libressl}/${rfile}"
rurl="https://www.usenix.org.uk/mirrors/${rname%libressl}/archive/${rver%%.*}.x/${rfile}"
rsha256="77437cdd1aef1a621824bb3607e966534642fe90c69f4d2279a9da9fa36c3253"
rreqs="make libressl"
rpfile="${cwrecipe}/${rname%libressl}/${rname}.patches"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  cwfetchcheck \
    \"https://gitweb.gentoo.org/repo/gentoo.git/plain/net-misc/stunnel/files/stunnel-5.51-libressl.patch?id=5a85fb190b37206caed168691ad569c5c63932f7\" \
    \"${cwdl}/${rname%libressl}/stunnel-5.51-libressl.patch\" \
    \"8033ab3012b7e3e2b614e674b1fab06cab1a5674070217db5711c2eab8e6427e\"
}
"

eval "
function cwpatch_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  patch -p1 < \"${cwdl}/${rname%libressl}/stunnel-5.51-libressl.patch\"
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  grep -ril '/usr/bin/perl' . \
  | xargs sed -i \"s#/usr/bin/perl#${cwsw}/perl/current/bin/perl#g\"
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-fips \
    --disable-libwrap \
    --disable-systemd \
    --with-ssl=\"${cwsw}/libressl/current\" \
      LDFLAGS=-static \
      CPPFLAGS= \
      PKG_CONFIG_LIBDIR= \
      PKG_CONFIG_PATH=
  find . -type f -name Makefile -exec sed -i 's/-fPIE/-fPIC/g' {} \;
  find . -type f -name Makefile -exec sed -i 's/-pie//g' {} \;
  cwmkdir \"${ridir}/bin\"
  ln -sf \"${rtdir}/current/bin/${rname%libressl}\" \"${ridir}/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname%libressl}\" \"${ridir}/bin/${rname%libressl}-${rname#stunnel}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir%libressl}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir%libressl}libressl/current/bin\"' >> \"${rprof}\"
}
"
