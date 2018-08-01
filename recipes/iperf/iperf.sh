rname="iperf"
rver="2.0.12"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://sourceforge.net/projects/iperf2/files/${rfile}"
rsha256="367f651fb1264b13f6518e41b8a7e08ce3e41b2a1c80e99ff0347561eed32646"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
