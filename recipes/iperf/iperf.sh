rname="iperf"
rver="2.1.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://sourceforge.net/projects/iperf2/files/${rfile}"
rsha256="dfe2197e2842fe9c9d9677bf1cb20a5a9ccfcb9a9de79f9927c39f73204ba003"
rreqs="make configgit"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
