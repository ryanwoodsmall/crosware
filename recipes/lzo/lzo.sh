rname="lzo"
rver="2.10"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://www.oberhumer.com/opensource/${rname}/download/${rfile}"
rsha256="c0f892943208266f9b6543b3ae308fab6284c5c90e627931446fb49b4221a072"
rreqs="make slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --disable-asm
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
