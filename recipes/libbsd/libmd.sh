#
# XXX - safe to enable pkg-config bits *only*?
#
rname="libmd"
rver="1.1.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://libbsd.freedesktop.org/releases/${rfile}"
rsha256="1bd6aa42275313af3141c7cf2e5b964e8b1fd488025caf2f971f43b00776b332"
rreqs="make"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} LDFLAGS=-static CPPFLAGS= PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"
