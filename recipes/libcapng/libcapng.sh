rname="libcapng"
rver="0.8.4"
rdir="libcap-ng-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://people.redhat.com/sgrubb/libcap-ng/${rfile}"
rsha256="68581d3b38e7553cb6f6ddf7813b1fc99e52856f21421f7b477ce5abd2605a8a"
rreqs="make slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --without-python{,3} ${rconfigureopts} ${rcommonopts}
  popd >/dev/null 2>&1
}
"
