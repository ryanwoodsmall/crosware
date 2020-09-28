rname="libffi"
rver="3.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="ftp://sourceware.org/pub/${rname}/${rfile}"
rsha256="72fba7922703ddfa7a028d513ac15a85c8d54c8d67f55fa5a4802885dc652056"
rreqs="make configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts}
  sed -i.ORIG 's/__gnu_linux__/__linux__/g' src/closures.c
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
