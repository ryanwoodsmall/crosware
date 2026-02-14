rname="ed"
rver="1.22.5"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.lz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="56e107ddc2f29dad6690376c15bf9751509e1ee3b8241710e44edbe5c3a158cc"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} CC=\"\${CC}\" CFLAGS=\"\${CFLAGS}\" LDFLAGS=-static CPPFLAGS=
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
