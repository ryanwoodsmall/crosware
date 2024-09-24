#
# XXX - version history, not sure where else to link this: https://mywiki.wooledge.org/BashFAQ/061
#
rname="bash"
rver="5.2.37"
rdir="${rname}-${rver}"
rbdir="${cwbuild}/${rname}-${rver%.*}"
rfile="${rname}-${rver%.*}.tar.gz"
#rbdir="${cwbuild}/${rname}-${rver}"
#rfile="${rname}-${rver}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="a139c166df7ff4471c5e0733051642ee5556c1cc8a4a78f145583c5c81ab32fb"

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
