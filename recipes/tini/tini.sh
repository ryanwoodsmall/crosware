rname="tini"
rver="0.18.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/krallin/${rname}/archive/${rfile}"
rsha256="1097675352d6317b547e73f9dc7c6839fd0bb0d96dafc2e5c95506bb324049a2"
rreqs=""

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1 
  echo '#define TINI_VERSION \"${rver}\"' > ./src/tiniConfig.h
  echo '#define TINI_GIT \"\"' >> ./src/tiniConfig.h
  popd >/dev/null 2>&1 
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}/src\" >/dev/null 2>&1 
  \${CC} \"${rname}.c\" -o \"${rname}\" -static
  popd >/dev/null 2>&1 
}
"

# XXX - init symlink?
#  ln -sf \"${rtdir}/current/sbin/${rname}\" \"${ridir}/sbin/init\"
eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}/src\" >/dev/null 2>&1 
  cwmkdir \"${ridir}/sbin\"
  install -m 0755 \"${rname}\" \"${ridir}/sbin/${rname}\"
  popd >/dev/null 2>&1 
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > "${rprof}"
}
"
