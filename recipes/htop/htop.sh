rname="htop"
rver="3.0.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://bintray.com/${rname}/source/download_file?file_path=${rfile}"
rsha256="e9dbf91e621216e7baab6b72ae2251b57e9d3c7b20682a826f627b618eb0fe1b"
rreqs="make ncurses python3"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} CC=\"\${CC} \${CFLAGS} \${LDFLAGS}\"
  sed -i.ORIG \"s|/usr/bin/env python.*|${cwsw}/python3/current/bin/python3|g\" scripts/MakeHeader.py
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
