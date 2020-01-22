rname="utillinux"
rver="2.35"
rdir="util-linux-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://kernel.org/pub/linux/utils/util-linux/v${rver}/${rfile}"
rsha256="b3081b560268c1ec3367e035234e91616fa7923a0afc2b1c80a2a6d8b9dfe2c9"
rreqs="make zlib ncurses readline gettexttiny slibtool pcre2"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG '/READLINE_LIBS/ s/-lreadline/-lreadline -lncurses -lncursesw/g' configure
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-makeinstall-chown \
    --disable-makeinstall-setuid \
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
