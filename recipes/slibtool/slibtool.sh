rname="slibtool"
rver="0.7.1"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/midipix-project/slibtool/archive/refs/tags/${rfile}"
rsha256="18d8c5e82e41ab36daece81777028d89691f501a447055755d06f47fe4710649"
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
