#
# XXX - opt-in only for now
# XXX - moving to https://gitea.treehouse.systems/ariadne/pkgconf
#

rname="pkgconf"
rver="1.9.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
#rurl="https://github.com/${rname}/${rname}/archive/refs/tags/${rfile}"
#rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rurl="https://distfiles.dereferenced.org/${rname}/${rfile}"
rsha256="daccf1bbe5a30d149b556c7d2ffffeafd76d7b514e249271abdd501533c1d8ae"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    CC=\"\${CC} -Os -Wl,-s\" \
    CFLAGS=\"\${CFLAGS} -Os -Wl,-s\" \
    CXXFLAGS=\"\${CXXFLAGS} -Os -Wl,-s\" \
    LDFLAGS=\"\${LDFLAGS} -static -s\" \
    PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"
