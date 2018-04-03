rname="zutils"
rver="1.7"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.lz"
rurl="http://download.savannah.gnu.org/releases/${rname}/${rfile}"
rsha256="c4ffadab70458fab8f1fe51b003f953c590d95e060658105622144bdd93ba650"
# diff is needed, use busybox version for now
rreqs="make busybox lunzip"

. "${cwrecipe}/common.sh"

eval "
function cwextract_${rname}() {
  pushd "${cwbuild}" >/dev/null 2>&1
  cwscriptecho \"extracting ${rfile} in ${cwbuild}\"
  lunzip -dc "${cwdl}/${rname}/${rfile}" | tar -xf -
  popd >/dev/null 2>&1
}
"

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
