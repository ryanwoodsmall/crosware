rname="tinycurl772"
rver="7.72.0"
rdir="tiny-curl-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://curl.se/tiny/${rfile}"
rsha256="f903cfcd008615d194f80a2b1c1f261609cea9c764eb9daaff92bf99040f7730"
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
