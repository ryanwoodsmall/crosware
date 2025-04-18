rname="termcap"
rver="1.3.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="91a0e22e5387ca4467b5bcb18edf1c51b930262fd466d5fda396dd9d26719100"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwpatch_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  sed -i.ORIG 's,/usr/local,${ridir},g' configure
  sed -i.ORIG 's,/usr/include,${ridir}/include,g' Makefile.in
  popd &>/dev/null
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  env CPPFLAGS= LDFLAGS=-static \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
      --enable-install-termcap \
      --with-termcap=\"${ridir}/etc/termcap\"
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  make -j${cwmakejobs} ${rlibtool} CPPFLAGS= LDFLAGS=-static
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  cwmkdir \"${ridir}/etc\"
  make install
  install -m 644 termcap.src \"${ridir}/etc/\"
  popd &>/dev/null
}
"
