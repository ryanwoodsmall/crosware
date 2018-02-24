rname="byacc"
rver="20170709"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/${rfile}"
rsha256="27cf801985dc6082b8732522588a7b64377dd3df841d584ba6150bc86d78d9eb"
rprof="${cwetcprofd}/${rname}.sh"
rreqs="make m4 flex"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path "${cwsw}/${rname}/current/bin"' > "${rprof}"
}
"
