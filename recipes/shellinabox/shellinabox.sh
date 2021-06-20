#
# XXX - gen self-signed cert with https://www.ibm.com/support/knowledgecenter/SSMNED_5.0.0/com.ibm.apic.cmc.doc/task_apionprem_gernerate_self_signed_openSSL.html
# XXX - libressl variant
# XXX - couple with sslh for regular ssh+https/tls on same port
# XXX - add wrapper script for startup with ssh to localhost
#
#  #!/usr/bin/env bash
#  siabtop="${cwsw}/shellinabox/current"
#  siabcss="${siabtop}/share/shellinabox/css"
#  siabport=4200
#  siabuser="${USER:-ryan}"
#  siabgroup="${USER:-ryan}"
#  sshport=2222
#  mkdir -p "${siabtop}/cert"
#  ${siabtop}/bin/shellinaboxd \
#    --user-css="Normal:+${siabcss}/white-on-black.css,Reverse:-${siabcss}/black-on-white.css" \
#    --port=${siabport} \
#    --user=${siabuser} \
#    --service=/siab/ssh/localhost:${siabuser}:${siabgroup}:HOME:"/usr/bin/ssh -l ${siabuser} -p ${sshport} -o PubkeyAuthentication=no localhost" \
#    --cert="${siabtop}/cert" \
#    --localhost-only \
#    --background="${cwtop}/tmp/shellinabox.pid" \
#    --disable-ssl-menu \
#      >>"${cwtop}/tmp/shellinabox.log" 2>&1
#

rname="shellinabox"
rver="2.20"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/${rname}/${rname}/archive/${rfile}"
rsha256="27a5ec6c3439f87aee238c47cc56e7357a6249e5ca9ed0f044f0057ef389d81e"
rreqs="make autoconf automake libtool openssl zlib slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=\"${cwsw}/ccache/current/bin:${cwsw}/autoconf/current/bin:${cwsw}/automake/current/bin:${cwsw}/libtool/current/bin:\${PATH}\" \
    autoreconf -I${cwsw}/libtool/current/share/aclocal -fiv
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --disable-{pam,runtime-loading,utmp} LIBS='-lssl -lcrypto -lz'
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  cwmkdir \"${ridir}/share/${rname}/css\"
  install -m 0644 shellinabox/*.css \"${ridir}/share/${rname}/css/\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
