rname="sysklogd"
rver="2.8.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/troglobit/sysklogd/releases/download/v${rver}/${rfile}"
rsha256="67f49c6b2e9d75ce15202db815112719f4af0db8901032f0c3a0cec1b9f65551"
rreqs="bootstrapmake slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --sysconfdir=\"${cwtop}/etc/${rname}\" \
    --localstatedir=\"${cwtop}/var\" \
    --with-logger \
    --without-systemd \
      LDFLAGS='-s -static' \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool}
  cwmkdir \"${cwtop}/etc/${rname}\"
  cwmkdir \"${cwtop}/var/log\"
  install -m 644 syslog.conf \"${cwtop}/etc/${rname}/syslog.conf.example\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"
