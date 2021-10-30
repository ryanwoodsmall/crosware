rname="file"
rver="5.41"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://astron.com/pub/${rname}/${rfile}"
rsha256="13e532c7b364f7d57e23dfeea3147103150cb90593a57af86c10e4f6e411603f"
rreqs="make zlib bzip2 xz"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
