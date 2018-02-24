rname="m4"
rver="1.4.18"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="6640d76b043bc658139c8903e293d5978309bf0f408107146505eca701e67cf6"
rprof="${cwetcprofd}/${rname}.sh"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path "${cwsw}/${rname}/current/bin"' > "${rprof}"
}
"
