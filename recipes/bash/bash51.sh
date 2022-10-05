rname="bash51"
rver="5.1.16"
rdir="${rname%51}-${rver}"
rbdir="${cwbuild}/${rname%51}-${rver%.*}"
rfile="${rname%51}-${rver%.*}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname%51}/${rfile}"
rsha256="cc012bc860406dcf42f64431bcd3d2fa7560c02915a601aba9cd597a39329baa"
rpfile="${cwrecipe}/${rname%51}/${rname}.patches"

. "${cwrecipe}/${rname%51}/${rname%51}.sh.common"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make strip
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 0755 bash \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname%51}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname}-${rver}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname}-${rver%.*}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/sh\"
  popd >/dev/null 2>&1
}
"
