rname="slibtool"
rver="0.5.35"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/midipix-project/slibtool/archive/refs/tags/${rfile}"
rsha256="a93294fa3ad44d690448341a5bb0234f985f8a57be660c03180c27db4a809840"
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
