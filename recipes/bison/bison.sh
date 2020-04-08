#
# XXX - --enable-relocatable configure option?
#

rname="bison"
rver="3.5.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="4c17e99881978fa32c05933c5262457fa5b2b611668454f8dc2a695cd6b3720c"
rreqs="make m4 flex perl sed gawk"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
}
"
