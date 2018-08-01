rname="file"
rver="5.34"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="ftp://ftp.astron.com/pub/${rname}/${rfile}"
rsha256="f15a50dbbfa83fec0bd1161e8e191b092ec832720e30cd14536e044ac623b20a"
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
