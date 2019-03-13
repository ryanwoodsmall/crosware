rname="file"
rver="5.36"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="ftp://ftp.astron.com/pub/${rname}/${rfile}"
rsha256="fb608290c0fd2405a8f63e5717abf6d03e22e183fb21884413d1edd918184379"
rreqs="make zlib"

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
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
