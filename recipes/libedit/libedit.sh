rname="libedit"
rver="20190324-3.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.thrysoee.dk/editline/${rfile}"
rsha256="ac8f0f51c1cf65492e4d1e3ed2be360bda41e54633444666422fbf393bba1bae"
rreqs="make ncurses"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' > \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
