rname="libcapng"
rver="0.8.3"
rdir="libcap-ng-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://people.redhat.com/sgrubb/libcap-ng/${rfile}"
rsha256="bed6f6848e22bb2f83b5f764b2aef0ed393054e803a8e3a8711cb2a39e6b492d"
rreqs="make slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --without-python{,3} ${rconfigureopts} ${rcommonopts}
  popd >/dev/null 2>&1
}
"
