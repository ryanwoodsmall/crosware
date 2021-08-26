rname="jansson"
rver="2.13.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://digip.org/${rname}/releases/${rfile}"
rsha256="ee90a0f879d2b7b7159124ff22b937a2a9a8c36d3bb65d1da7dd3f04370a10bd"
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
