#
# XXX - version history, not sure where else to link this: https://mywiki.wooledge.org/BashFAQ/061
#

rname="bash"
rver="5.2.9"
rdir="${rname}-${rver}"
#rbdir="${cwbuild}/${rname}-${rver%.*}"
#rfile="${rname}-${rver%.*}.tar.gz"
rbdir="${cwbuild}/${rname}-${rver}"
rfile="${rname}-${rver}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="68d978264253bc933d692f1de195e2e5b463a3984dfb4e5504b076865f16b6dd"

. "${cwrecipe}/${rname}/${rname}.sh.common"

# XXX - ugh, lib/sh/strtoimax.c - broken on alpine too
eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  echo > lib/sh/strtoimax.c
  make -j${cwmakejobs} ${rlibtool}
  popd >/dev/null 2>&1
}
"

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
