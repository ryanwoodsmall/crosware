rname="libxml2"
rver="2.9.12"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="ftp://xmlsoft.org/${rname}/${rfile}"
#rurl="https://sources.voidlinux.org/${rdir}/${rfile}"
rurl="http://xmlsoft.org/sources/${rfile}"
rsha256="c8d6681e38c56f172892c85ddc0852e1fd4b53b4209e7f4ebf17f7e2eae71d92"
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
