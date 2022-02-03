rname="rcs"
rver="5.10.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.lz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="43ddfe10724a8b85e2468f6403b6000737186f01e60e0bd62fde69d842234cc5"
rreqs="make sed gettexttiny ed diffutils lunzip"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
