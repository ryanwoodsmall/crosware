#
# XXX - opt-in only for now
# XXX - moving to https://gitea.treehouse.systems/ariadne/pkgconf
#
rname="pkgconf"
rver="2.3.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="https://github.com/${rname}/${rname}/archive/refs/tags/${rfile}"
#rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rurl="https://distfiles.dereferenced.org/${rname}/${rfile}"
rsha256="a2df680578e85f609f2fa67bd3d0fc0dc71b4bf084fc49119de84cd6ed28e723"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --enable-year2038 \
      CC=\"\${CC} -Os -Wl,-s\" \
      CFLAGS=\"\${CFLAGS} -Os -Wl,-s\" \
      CXXFLAGS=\"\${CXXFLAGS} -Os -Wl,-s\" \
      LDFLAGS=\"\${LDFLAGS} -static -s\" \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"
