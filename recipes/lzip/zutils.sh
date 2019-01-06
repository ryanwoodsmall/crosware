rname="zutils"
rver="1.8"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.lz"
rurl="http://download.savannah.gnu.org/releases/${rname}/${rfile}"
rsha256="07a47e1602be66a166bd3bf99c80efe2df889e2d407fadcd7ff83974762da337"
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
