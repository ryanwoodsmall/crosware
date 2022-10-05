rname="bash50"
rver="5.0.18"
rdir="${rname%50}-${rver}"
rbdir="${cwbuild}/${rname%50}-${rver%.*}"
rfile="${rname%50}-${rver%.*}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname%50}/${rfile}"
rsha256="b4a80f2ac66170b2913efbfb9f2594f1f76c7b1afd11f799e22035d63077fb4d"
rpfile="${cwrecipe}/${rname%50}/${rname}.patches"

. "${cwrecipe}/${rname%50}/${rname%50}.sh.common"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make strip
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 0755 bash \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname%50}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname}-${rver}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname}-${rver%.*}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/sh\"
  popd >/dev/null 2>&1
}
"
