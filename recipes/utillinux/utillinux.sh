rname="utillinux"
rver="2.36.2"
rdir="util-linux-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://kernel.org/pub/linux/utils/util-linux/v${rver%.?}/${rfile}"
#rurl="https://kernel.org/pub/linux/utils/util-linux/v${rver}/${rfile}"
rsha256="f7516ba9d8689343594356f0e5e1a5f0da34adfbc89023437735872bb5024c5f"
rreqs="make zlib ncurses readline gettexttiny slibtool pcre2"

. "${cwrecipe}/common.sh"

# XXX - something with 2.35.1 to 2.35.2 broke SYS_pidfd_... checks/definitions
eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  cat include/pidfd-utils.h > include/pidfd-utils.h.ORIG
  echo '#include <sys/types.h>' > include/pidfd-utils.h
  cat include/pidfd-utils.h.ORIG >> include/pidfd-utils.h
  sed -i '/defined.*__linux/s/$/ \\&\\& defined(SYS_pidfd_send_signal)/g' include/pidfd-utils.h
  sed -i.ORIG '/READLINE_LIBS/ s/-lreadline/-lreadline -lncurses -lncursesw/g' configure
  env PATH=\"${cwsw}/ncurses/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
      --disable-makeinstall-chown \
      --disable-makeinstall-setuid \
      --disable-nls \
      --disable-pylibmount \
      --enable-line \
      --enable-pg \
      --enable-write \
      --with-readline \
      --without-cap-ng \
      --without-python \
      --without-selinux \
      --without-smack \
      --without-systemd \
        LIBS='-lreadline -lncurses -lncursesw' \
        LIBTOOL=\"${cwsw}/slibtool/current/bin/slibtool-static -all-static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
