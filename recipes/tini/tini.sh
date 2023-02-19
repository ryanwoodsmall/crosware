rname="tini"
rver="0.19.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/krallin/${rname}/archive/${rfile}"
rsha256="0fd35a7030052acd9f58948d1d900fe1e432ee37103c5561554408bdac6bbf0d"
rreqs=""

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  echo '#define TINI_VERSION \"${rver}\"' > ./src/tiniConfig.h
  echo '#define TINI_GIT \"\"' >> ./src/tiniConfig.h
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})/src\" >/dev/null 2>&1
  \${CC} \${CFLAGS} -g0 -Os -Wl,-s \"${rname}.c\" -o \"${rname}\" -static -s
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})/src\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/sbin\"
  install -m 0755 \"${rname}\" \"\$(cwidir_${rname})/sbin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > "${rprof}"
}
"
