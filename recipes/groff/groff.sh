rname="groff"
rver="1.22.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="3a48a9d6c97750bfbd535feeb5be0111db6406ddb7bb79fc680809cda6d828a5"
rreqs="make perl"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
