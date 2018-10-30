rname="bison"
rver="3.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="deec377b95aa72ec4e1a33fe2c938d2480749d740b5291a7cc1d77808d3710bf"
rreqs="make m4 flex perl sed"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
}
"
