rname="jansson"
rver="2.14"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://github.com/akheron/${rname}/releases/download/v${rver}/${rfile}"
rsha256="fba956f27c6ae56ce6dfd52fbf9d20254aad42821f74fa52f83957625294afb9"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    LDFLAGS=-static CPPFLAGS= PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"
