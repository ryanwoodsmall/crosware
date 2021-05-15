rname="libxml2"
rver="2.9.11"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="ftp://xmlsoft.org/${rname}/${rfile}"
#rurl="https://sources.voidlinux.org/${rdir}/${rfile}"
rurl="http://xmlsoft.org/sources/${rfile}"
rsha256="886f696d5d5b45d780b2880645edf9e0c62a4fd6841b853e824ada4e02b4d331"
rreqs="make xz zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --without-python
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include/${rname}\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
