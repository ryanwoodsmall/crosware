rname="iperf"
rver="2.1.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://sourceforge.net/projects/iperf2/files/${rfile}"
rsha256="9873b540131049dac04887296ebb69f4992036715e9045c7efe00e7a3c7f3308"
rreqs="make configgit"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
