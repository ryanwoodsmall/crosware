rname="sysklogd"
rver="2.6.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/troglobit/sysklogd/releases/download/v${rver}/${rfile}"
rsha256="40a3bb593d7507e49a4379f48ae8a9bc4b68dcc583efcdbf3b9056128442c92a"
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
