rname="expat"
rver="2.2.7"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://github.com/libexpat/libexpat/releases/download/R_${rver//./_}/${rfile}"
rsha256="cbc9102f4a31a8dafd42d642e9a3aa31e79a0aedaa1f6efd2795ebc83174ec18"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --without-docbook
  sed -i \"s#${ridir}#${rtdir}/current#g\" ${rname}.pc
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
