rname="ctags"
rver="5.8"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://prdownloads.sourceforge.net/${rname}/${rfile}"
rsha256="0e44b45dcabe969e0bbbb11e30c246f81abe5d32012db37395eb57d66e9e99c7"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
