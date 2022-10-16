rname="zutils"
rver="1.11"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.lz"
rurl="http://download.savannah.gnu.org/releases/${rname}/${rfile}"
rsha256="50e8e24b0a280ccab037004b9000b070d17a6e0cd86972927d1b2a5505421389"
# diff is needed, use busybox version for now
rreqs="make busybox lunzip"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} CPPFLAGS=\"\${CPPFLAGS}\" LDFLAGS=\"\${LDFLAGS}\" CC=\"\${CC}\" CFLAGS=\"\${CFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
