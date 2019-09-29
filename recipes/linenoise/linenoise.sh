rname="linenoise"
rver="4a961c0108720741e2683868eb10495f015ee422"
rdir="${rname}-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/antirez/${rname}/archive/${rfile}"
rsha256="e654e704e504896d0f152edf2f79f1ddd9857969a0952df874578a0bd34ff15a"
rreqs=""

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  \${CC} -fPIC -Os -g -c -o ${rname}.{o,c}
  ar rcs lib${rname}.a ${rname}.o
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  mkdir -p \"${ridir}/include\" \"${ridir}/lib\"
  install -m 644 ${rname}.h \"${ridir}/include/\"
  install -m 644 lib${rname}.a \"${ridir}/lib/\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
