rname="htop"
rver="2.1.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://hisham.hm/${rname}/releases/${rver}/${rfile}"
rsha256="3260be990d26e25b6b49fc9d96dbc935ad46e61083c0b7f6df413e513bf80748"
rreqs="make ncurses"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
