rname="htop"
rver="2.2.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://hisham.hm/${rname}/releases/${rver}/${rfile}"
rsha256="d9d6826f10ce3887950d709b53ee1d8c1849a70fa38e91d5896ad8cbc6ba3c57"
rreqs="make ncurses python3"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG 's/ python/ python3/g' scripts/MakeHeader.py
  ./configure ${cwconfigureprefix} CC=\"\${CC} \${CFLAGS} \${LDFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
