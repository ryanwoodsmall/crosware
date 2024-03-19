rname="slibtool"
rver="0.5.36"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/midipix-project/slibtool/archive/refs/tags/${rfile}"
rsha256="90334fe8b6271d55953543c7202a05f8d34f6a90a9afcacc0ef2f52a3e23e345"
rreqs="make m4"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env \
    CXXFLAGS='-Wl,-static -fPIC' \
    CFLAGS='-Wl,-static -fPIC' \
      ./configure ${cwconfigureprefix} --all-static
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make -j${cwmakejobs} CFLAGS_CMDLINE='-Wl,-static -fPIC'
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install CFLAGS_CMDLINE='-Wl,-static -fPIC'
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
