rname="ed"
rver="1.16"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.lz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="cfc07a14ab048a758473ce222e784fbf031485bcd54a76f74acfee1f390d8b2c"
rreqs="make lunzip"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} CC=\"\${CC}\" CFLAGS=\"\${CFLAGS}\" CPPFLAGS=\"\${CPPFLAGS}\" LDFLAGS=\"\${LDFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
