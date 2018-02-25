rname="htop"
rver="2.1.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://hisham.hm/${rname}/releases/${rver}/${rfile}"
rsha256="3260be990d26e25b6b49fc9d96dbc935ad46e61083c0b7f6df413e513bf80748"
rreqs="make ncurses jython"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} CC=\"\${CC} \${CFLAGS} \${LDFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  mkdir -p buildbin
  ln -s \$(which jython) buildbin/python
  env PATH=\"./buildbin:\${PATH}\" make
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
