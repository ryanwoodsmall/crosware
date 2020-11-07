rname="iperf"
rver="2.0.13"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://sourceforge.net/projects/iperf2/files/${rfile}"
rsha256="c88adec966096a81136dda91b4bd19c27aae06df4d45a7f547a8e50d723778ad"
rreqs="make configgit"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
