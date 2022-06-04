#
# XXX - uses a github commit, download every time
#
rname="simh4"
rver="a06fa9264f5efe1deec362e03ec571cbec0d98be"
rdir="${rname%4}-${rver}"
rfile="${rver%4}.zip"
rurl="https://github.com/simh/simh/archive/${rfile}"
rsha256=""

. "${cwrecipe}/simh/simh.sh.common"

eval "
function cwfetch_${rname}() {
  cwfetch \"${rurl}\" \"${rdlfile}\"
}
"
