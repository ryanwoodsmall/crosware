rname="bison"
rver="3.0.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="b67fd2daae7a64b5ba862c66c07c1addb9e6b1b05c5f2049392cfd8a2172952e"
rprof="${cwetcprofd}/${rname}.sh"
rreqs="make m4 flex perl"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path "${cwsw}/${rname}/current/bin"' > "${rprof}"
}
"
