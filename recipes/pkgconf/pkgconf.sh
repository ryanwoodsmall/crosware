#
# XXX - opt-in only for now
#

rname="pkgconf"
rver="1.8.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="https://github.com/${rname}/${rname}/archive/refs/tags/${rfile}"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="656724aa2529b63205a2a229eb01c030d70684ed7129262c654db76c85463bc8"
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
