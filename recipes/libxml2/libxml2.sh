rname="libxml2"
rver="2.9.14"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
#rurl="ftp://xmlsoft.org/${rname}/${rfile}"
#rurl="https://sources.voidlinux.org/${rdir}/${rfile}"
#rurl="http://xmlsoft.org/sources/${rfile}"
rurl="https://download.gnome.org/sources/${rname}/${rver%.*}/${rfile}"
rsha256="60d74a257d1ccec0475e749cba2f21559e48139efba6ff28224357c7c798dfee"
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
