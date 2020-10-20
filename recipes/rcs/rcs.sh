rname="rcs"
rver="5.10.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="3a0d9f958c7ad303e475e8634654974edbe6deb3a454491f3857dc1889bac5c5"
rreqs="make sed gettexttiny ed diffutils"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
