rname="htop"
rver="3.0.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://bintray.com/${rname}/source/download_file?file_path=${rfile}"
rsha256="80366282a11058a8ef55756a659de72804404fa1f644c210a4b7c45b6c9fde3d"
rreqs="make ncurses python3"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG \"s|/usr/bin/env python.*|${cwsw}/python3/current/bin/python3|g\" scripts/MakeHeader.py
  ./configure ${cwconfigureprefix} CC=\"\${CC} \${CFLAGS} \${LDFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
