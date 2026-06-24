#
# XXX - opt-in only for now
#
# XXX - 2.9.90 breaks with muon
#     rver="2.9.90"
#     rurl="https://github.com/pkgconf/pkgconf/releases/download/${rdir}/${rfile}"
#     rsha256="e87eef36b5b016f84f802b468435d2c14dd29c6bcba57c8668f2d68382c43480"
#
# XXX - add to configure
#     --with-personality-dir
#     --with-pkg-config-dir
#     --with-system-includedir
#     --with-system-libdir
#
rname="pkgconf"
rver="2.5.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://distfiles.dereferenced.org/pkgconf/${rfile}"
rsha256="ab89d59810d9cad5dfcd508f25efab8ea0b1c8e7bad91c2b6351f13e6a5940d8"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --enable-year2038 \
    --with-pic \
      CC=\"\${CC} -Os -Wl,-s\" \
      CFLAGS=\"\${CFLAGS} -Os -Wl,-s\" \
      CXXFLAGS=\"\${CXXFLAGS} -Os -Wl,-s\" \
      LDFLAGS=\"\${LDFLAGS} -static -s\" \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"
