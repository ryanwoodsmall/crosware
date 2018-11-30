rname="uucp"
rver="1.07"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="060c15bfba6cfd1171ad81f782789032113e199a5aded8f8e0c1c5bd1385b62c"
rreqs="make sed"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > "${rprof}"
  echo 'append_path \"${rtdir}/current/bin\"' >> "${rprof}"
}
"
