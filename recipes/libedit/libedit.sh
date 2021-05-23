rname="libedit"
rver="20210522-3.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.thrysoee.dk/editline/${rfile}"
rsha256="0220bc2047e927c0c1984ef5f7b4eb2a9469a5b7bf12ba573ca3b23ca02bbb6f"
rreqs="make ncurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} CFLAGS=\"\${CFLAGS} -D__STDC_ISO_10646__=201206L\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' > \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
