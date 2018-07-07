rname="utillinux"
rver="2.32"
rdir="util-linux-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://kernel.org/pub/linux/utils/util-linux/v${rver}/${rfile}"
rsha256="6c7397abc764e32e8159c2e96042874a190303e77adceb4ac5bd502a272a4734"
rreqs="make zlib ncurses readline gettexttiny slibtool"

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
      LIBTOOL='slibtool-static -all-static'
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make -j${cwmakejobs} LIBTOOL='slibtool-static -all-static'
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make install LIBTOOL='slibtool-static -all-static'
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
