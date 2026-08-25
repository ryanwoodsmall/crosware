rname="ed"
rver="1.22.6"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.lz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="3f33b22135219c39c3c695f7b7171c2567d3e2a17c798c0a90607320cbb268f2"
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
