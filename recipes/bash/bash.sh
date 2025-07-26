#
# XXX - version history, not sure where else to link this: https://mywiki.wooledge.org/BashFAQ/061
#
rname="bash"
rver="5.3.3"
rmaj="${rver%%.*}"
rmin="${rver#${rmaj}.}"
rmin="${rmin%%.*}"
rdir="${rname}-${rver}"
rbdir="${cwbuild}/${rname}-${rmaj}.${rmin}"
rfile="${rname}-${rmaj}.${rmin}.tar.gz"
#rbdir="${cwbuild}/${rname}-${rver}"
#rfile="${rname}-${rver}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="62dd49c44c399ed1b3f7f731e87a782334d834f08e098a35f2c87547d5dbb269"
unset rmaj rmin

. "${cwrecipe}/${rname}/${rname}.sh.common"

# XXX - ugh, lib/sh/strtoimax.c - broken on alpine too
eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  echo > lib/sh/strtoimax.c
  make -j${cwmakejobs} ${rlibtool}
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make strip
  make install
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname}-${rver%.*}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname}-${rver%%.*}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname}${rver%%.*}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/sh\"
  popd &>/dev/null
}
"
