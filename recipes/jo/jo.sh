rname="jo"
rver="1.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/jpmens/${rname}/releases/download/${rver}/${rfile}"
rsha256="de25c95671a3b392c6bcaba0b15d48eb8e2435508008c29477982d2d2f5ade64"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
