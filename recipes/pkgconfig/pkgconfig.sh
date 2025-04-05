rname="pkgconfig"
rver="0.29.2"
rdir="pkg-config-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://pkg-config.freedesktop.org/releases/${rfile}"
rsha256="6fc69c01688c9458a57eb9a1664c9aba372ccda420a02bf4429fe610e7e7d591"
rreqs="bootstrapmake configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i 's/-Werror=missing-include-dirs//g' glib/configure
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --with-internal-glib \
    --with-system-library-path='/lib:/lib64:/usr/lib:/usr/lib64' \
      LDFLAGS=-static \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}='${cwsw}/${rname}/current/lib/pkgconfig'
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
