#
# XXX - moved may/june of 2025
#   - repository: https://git.foss21.org/cross/slibtool
#   - issue tracker: https://dev.midipix.org/cross/slibtool
#   - tarballs: https://dl.foss21.org/slibtool
#
rname="slibtool"
rver="0.7.4"
rdir="${rname}-${rver}"
#rfile="v${rver}.tar.gz"
#rurl="https://github.com/midipix-project/slibtool/archive/refs/tags/${rfile}"
rfile="${rdir}.tar.gz"
rurl="https://dl.foss21.org/slibtool/${rfile}"
rsha256="bad9e038f3a490568135845631dff6b0ba5861d9d9cd558b84cd58504131b184"
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
