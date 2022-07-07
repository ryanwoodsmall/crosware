rname="file"
rver="5.42"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://astron.com/pub/${rname}/${rfile}"
rsha256="c076fb4d029c74073f15c43361ef572cfb868407d347190ba834af3b1639b0e4"
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
