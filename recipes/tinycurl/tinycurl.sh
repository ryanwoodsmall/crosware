rname="tinycurl"
rver="8.4.0"
rdir="tiny-curl-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://curl.se/tiny/${rfile}"
rsha256="0b349aba6be4c1cd6216eb96062b2d405da3f04fb6798704b6ed971b67efef2e"
rreqs="${rname}wolfssl"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  mkdir -p ${rtdir}
  rm -rf \$(cwidir_${rname}) || true
  ln -sf \$(cwidir_\$(cwreqs_${rname} | cut -f1 -d' ')) \$(cwidir_${rname})
  popd >/dev/null 2>&1
}
"
