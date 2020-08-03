#
# XXX - --enable-relocatable configure option?
#

rname="bison"
rver="3.7.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="55c215521a13982a9bee68cd42eed51a65713f96c530a739a57de4438ac1bb69"
rreqs="make m4 flex perl sed gawk"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
}
"
