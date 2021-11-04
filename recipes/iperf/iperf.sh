rname="iperf"
rver="2.0.14a"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://sourceforge.net/projects/iperf2/files/${rfile}"
rsha256="4c8605b012addb7173ccde8348d7c5a701740295238ff5048992c38534c6a798"
rreqs="make configgit"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
