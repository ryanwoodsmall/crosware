rname="jo"
rver="1.5"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/jpmens/${rname}/releases/download/${rver}/${rfile}"
rsha256="e04490ac57175e10b91083c8d472f3b6b8bfa108fa5f59b1a4859ece258135b2"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
