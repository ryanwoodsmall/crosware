rname="jansson"
rver="2.14.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/akheron/jansson/releases/download/v${rver}/${rfile}"
rsha256="2521cd51a9641d7a4e457f7215a4cd5bb176f690bc11715ddeec483e85d9e2b3"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    LDFLAGS=-static CPPFLAGS= PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"
