rname="ed"
rver="1.22.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.lz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="47a55ddfc52d4a1ff6f7559fbd00cf948a16b6cf151ec520392761aeae4e97be"
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
