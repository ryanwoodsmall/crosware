#
# XXX - gen self-signed cert with https://www.ibm.com/support/knowledgecenter/SSMNED_5.0.0/com.ibm.apic.cmc.doc/task_apionprem_gernerate_self_signed_openSSL.html
# XXX - libressl variant
# XXX - couple with sslh for regular ssh+https/tls on same port
# XXX - gen keys, inbuilt impl seems a little finnicky
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
# cgi mode: https://github.com/shellinabox/shellinabox/blob/master/shellinabox/cgi-mode-example.sh
#
#  #!/bin/bash
#  cwtop="/usr/local/crosware"
#  cwsw="${cwtop}/software"
#  siab="${cwsw}/shellinabox/current"
#  "${siab}/bin/shellinaboxd" \
#    --cgi \
#    --disable-ssl \
#    --no-beep \
#    --service="/:$(id -u):$(id -g):HOME:/bin/bash" \
#    --user-css="Normal:+${siab}/share/shellinabox/css/white-on-black.css,Reverse:-${siab}/share/shellinabox/css/black-on-white.css"
#

rname="shellinabox"
rver="2.21"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/${rname}/${rname}/archive/${rfile}"
rsha256="2a8f94beb286d0851bb146f7a7c480a8740f59b959cbd274e21a8fcbf0a7f307"
rreqs="make autoconf automake libtool openssl zlib slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" &>/dev/null
  env PATH=\"${cwsw}/ccache/current/bin:${cwsw}/autoconf/current/bin:${cwsw}/automake/current/bin:${cwsw}/libtool/current/bin:\${PATH}\" \
    autoreconf -I${cwsw}/libtool/current/share/aclocal -fiv
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --disable-{pam,runtime-loading,utmp} LIBS='-lssl -lcrypto -lz'
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  make install ${rlibtool}
  cwmkdir \"${ridir}/share/${rname}/css\"
  install -m 0644 shellinabox/*.css \"${ridir}/share/${rname}/css/\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
