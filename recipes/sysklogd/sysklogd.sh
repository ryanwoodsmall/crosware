rname="sysklogd"
rver="2.5.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/troglobit/sysklogd/releases/download/v${rver}/${rfile}"
rsha256="e1d635944e5a6062c8ea18b9506668ebdaefacea1965147f60cf3fb3a25770e8"
rreqs="bootstrapmake slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --sysconfdir=\"${cwtop}/etc/${rname}\" \
    --localstatedir=\"${cwtop}/var\" \
    --with-logger \
    --without-systemd \
      LDFLAGS='-s -static' \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  cwmkdir \"${cwtop}/etc/${rname}\"
  cwmkdir \"${cwtop}/var/log\"
  install -m 644 syslog.conf \"${cwtop}/etc/${rname}/syslog.conf.example\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"
