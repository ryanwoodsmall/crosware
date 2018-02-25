rname="screen"
rver="4.6.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="1b6922520e6a0ce5e28768d620b0f640a6631397f95ccb043b70b91bb503fa3a"
rreqs="make ncurses"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
