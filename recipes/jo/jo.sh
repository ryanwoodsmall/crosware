rname="jo"
rver="1.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/jpmens/${rname}/releases/download/${rver}/${rfile}"
rsha256="36ec2fc4937c6478467684b18f0b213ff7267d34f5626cd5a0996a39ca64adae"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
