rname="jo"
rver="1.6"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/jpmens/${rname}/releases/download/${rver}/${rfile}"
rsha256="eb15592f1ba6d5a77468a1438a20e3d21c3d63bb7d045fb3544f223340fcd1a1"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
