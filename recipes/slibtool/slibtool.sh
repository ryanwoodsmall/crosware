rname="slibtool"
rver="0.7.2"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/midipix-project/slibtool/archive/refs/tags/${rfile}"
rsha256="cc25a3c71ee1facf71f932af1ee01058e462cd758a22c056ba007353851a28be"
rreqs="make m4"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env \
    CXXFLAGS='-Wl,-static -fPIC' \
    CFLAGS='-Wl,-static -fPIC' \
      ./configure ${cwconfigureprefix} --all-static
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make -j${cwmakejobs} CFLAGS_CMDLINE='-Wl,-static -fPIC'
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install CFLAGS_CMDLINE='-Wl,-static -fPIC'
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
