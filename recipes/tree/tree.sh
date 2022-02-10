#
# XXX - tree 2.x.x available, need to test against pass: http://mama.indstate.edu/users/ice/tree/changes.html
#

rname="tree"
rver="1.8.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="http://mama.indstate.edu/users/ice/${rname}/src/${rfile}"
rsha256="715d5d4b434321ce74706d0dd067505bb60c5ea83b5f0b3655dae40aa6f9b7c2"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG '/^prefix.*=/s#/usr#${ridir}#g' Makefile
  sed -i \"s#^CC=gcc#CC=\${CC}#g\" Makefile
  sed -i 's/^#LDFLAGS=\$/LDFLAGS=-static/g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
