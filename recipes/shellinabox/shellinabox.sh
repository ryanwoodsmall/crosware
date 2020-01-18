#
# XXX - gen self-signed cert with https://www.ibm.com/support/knowledgecenter/SSMNED_5.0.0/com.ibm.apic.cmc.doc/task_apionprem_gernerate_self_signed_openSSL.html
# XXX - add wrapper script for startup with ssh to localhost
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
