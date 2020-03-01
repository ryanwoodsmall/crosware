rname="libedit"
rver="20191231-3.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.thrysoee.dk/editline/${rfile}"
rsha256="dbb82cb7e116a5f8025d35ef5b4f7d4a3cdd0a3909a146a39112095a2d229071"
rreqs="make ncurses"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' > \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
