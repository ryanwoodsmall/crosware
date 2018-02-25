rname="qemacs"
rver="0.3.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://bellard.org/${rname}/${rfile}"
rsha256="2ffba66a44783849282199acfcc08707debc7169394a8fd0902626222f27df94"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure --prefix="${ridir}" \
    --enable-tiny \
    --disable-x11 \
    --disable-xv \
    --disable-xrender \
    --disable-html \
    --disable-png \
    --cc=\"\${CC}\" \
    --extra-cflags=\"\${CFLAGS}\" \
    --extra-ldflags=\"\${LDFLAGS}\"
  grep -v 'install.*html2png.*/bin' Makefile > Makefile.NEW
  sed '/^install:/ s/html2png//g' Makefile.NEW > Makefile
  sed -i 's/HOST_CC/CC/g;s/CFLAGS)/CFLAGS) \$(LDFLAGS)/g' libqhtml/Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  cwmkdir "${ridir}/bin"
  cwmkdir "${ridir}/man/man1"
  make install
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
