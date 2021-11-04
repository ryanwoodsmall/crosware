rname="iperf"
rver="2.1.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://sourceforge.net/projects/iperf2/files/${rfile}"
rsha256="062b392e87b8e227aca74fef0a99b04fe0382d4518957041b508a56885b4d4f9"
rreqs="make configgit"

. "${cwrecipe}/common.sh"

eval "
function cwpatch_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cat include/headers.h > include/headers.h.ORIG
  echo '#include <netinet/if_ether.h>' > include/headers.h
  cat include/headers.h.ORIG >> include/headers.h
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
