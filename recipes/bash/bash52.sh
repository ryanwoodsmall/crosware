rname="bash52"
rver="5.2.37"
rdir="${rname%52}-${rver}"
rbdir="${cwbuild}/${rname%52}-${rver%.*}"
rfile="${rname%52}-${rver%.*}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname%52}/${rfile}"
rsha256="a139c166df7ff4471c5e0733051642ee5556c1cc8a4a78f145583c5c81ab32fb"
rpfile="${cwrecipe}/${rname%52}/${rname}.patches"

. "${cwrecipe}/${rname%52}/${rname%52}.sh.common"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make strip
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 0755 bash \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname%52}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname}-${rver}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname}-${rver%.*}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/sh\"
  popd &>/dev/null
}
"
