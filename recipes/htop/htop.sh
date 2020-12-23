rname="htop"
rver="3.0.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://bintray.com/${rname}/source/download_file?file_path=${rfile}"
rsha256="3a403b4af4b5100a86183d3e9bb4839fcec99ac4368a60c242e9d7c742a34928"
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
