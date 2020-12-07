rname="htop"
rver="3.0.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://bintray.com/${rname}/source/download_file?file_path=${rfile}"
rsha256="5a0909956cd9289871269b1d146580b9c1e11218bb6d454c21d781161b6dae0f"
rreqs="make ncurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} CC=\"\${CC} \${CFLAGS} \${LDFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
