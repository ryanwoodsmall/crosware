rname="slang"
rver="2.3.1a"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://www.jedsoft.org/releases/${rname}/${rfile}"
rsha256="54f0c3007fde918039c058965dffdfd6c5aec0bad0f4227192cc486021f08c36"
rreqs="make zlib"

. "${cwrecipe}/common.sh"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make install-static
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
