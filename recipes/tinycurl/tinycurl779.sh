rname="tinycurl779"
rver="7.79.1"
rdir="tiny-curl-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://curl.se/tiny/${rfile}"
rsha256="a32d74d1e1a67e2bfc5aee07f82fc05c7a6ec676e8b4515355c731122066af81"
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
