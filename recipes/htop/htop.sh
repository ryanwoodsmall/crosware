rname="htop"
rver="3.0.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://bintray.com/${rname}/source/download_file?file_path=${rfile}"
rsha256="6471d9505daca5c64073fc37dbab4d012ca4fc6a7040a925dad4a7553e3349c4"
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
