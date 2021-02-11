rname="zutils"
rver="1.10"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.lz"
rurl="http://download.savannah.gnu.org/releases/${rname}/${rfile}"
rsha256="0dd44138292d5757648037195b6945c3df70b316221b4285520ad38f2eaeb195"
# diff is needed, use busybox version for now
rreqs="make busybox lunzip"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} CPPFLAGS=\"\${CPPFLAGS}\" LDFLAGS=\"\${LDFLAGS}\" CC=\"\${CC}\" CFLAGS=\"\${CFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
