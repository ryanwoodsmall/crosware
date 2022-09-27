#
# XXX - version history, not sure where else to link this: https://mywiki.wooledge.org/BashFAQ/061
#

rname="bash"
rver="5.1.16"
rdir="${rname}-${rver}"
rbdir="${cwbuild}/${rname}-${rver%.*}"
rfile="${rname}-${rver%.*}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="cc012bc860406dcf42f64431bcd3d2fa7560c02915a601aba9cd597a39329baa"
rreqs="make byacc sed netbsdcurses patch"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/${rname}/${rname}.sh.common"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make strip
  make install
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname}-${rver%.*}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname}-${rver%%.*}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname}${rver%%.*}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/sh\"
  popd >/dev/null 2>&1
}
"
