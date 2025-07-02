#
# XXX - moved may/june of 2025
#   - repository: https://git.foss21.org/cross/slibtool
#   - issue tracker: https://dev.midipix.org/cross/slibtool
#   - tarballs: https://dl.foss21.org/slibtool
#
rname="slibtool"
rver="0.7.3"
rdir="${rname}-${rver}"
#rfile="v${rver}.tar.gz"
#rurl="https://github.com/midipix-project/slibtool/archive/refs/tags/${rfile}"
rfile="${rdir}.tar.gz"
rurl="https://dl.foss21.org/slibtool/${rfile}"
rsha256="634736b9bbe16b04d7dc22abff0afb916dd56f45b4641e0afc542c6595035ea9"
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
