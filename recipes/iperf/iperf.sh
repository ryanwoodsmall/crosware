rname="iperf"
rver="2.0.14a"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://sourceforge.net/projects/iperf2/files/${rfile}"
rsha256="e9f600c79dd508e670c28a330fd48938f090a33aaab48b4071c2e843c000ce39"
rreqs="make configgit"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
