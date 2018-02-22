rfile=""
rsha256=""
rname="sbase"
rver="4b9c664"
rurl="https://git.suckless.org/${rname}"
rdir="${rname}-${rver}"
rprof="${cwetcprofd}/zz_${rname}.sh"
rreqs="jgitsh static-toolchain make"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname} {
  pushd "${cwbuild}/" >/dev/null 2>&1
  rm -rf "${rdir}"
  ${jgitsh_symlink} clone "${rurl}" "${rdir}"
  cd "${rdir}"
  ${jgitsh_symlink} checkout "${rver}"
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd "${cwbuild}/${rdir}" >/dev/null 2>&1
  sed -i '/^PREFIX/d' config.mk
  sed -i '/^CC/d' config.mk
  sed -i '/^AR/d' config.mk
  sed -i '/^LDFLAGS/d' config.mk
  echo "CC = \${CC}" >> config.mk
  echo "AR = \${AR}" >> config.mk
  echo "LDFLAGS = \${LDFLAGS}" >> config.mk
  echo "PREFIX = ${cwsw}/${rname}/${rdir}" >> config.mk
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/${rname}/current/bin\"' > "${rprof}"
}
"

eval "
function cwmake_${rname}() {
  pushd "${cwbuild}/${rdir}" >/dev/null 2>&1
  make sbase-box
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${cwbuild}/${rdir}" >/dev/null 2>&1
  make sbase-box-install
  popd >/dev/null 2>&1
}
"

eval "
function cwinstall_${rname}() {
  cwclean_${rname}
  cwcheckreqs_${rname}
  cwsourceprofile
  cwfetch_${rname}
  cwconfigure_${rname}
  cwmake_${rname}
  cwmakeinstall_${rname}
  cwlinkdir "${rdir}" "${cwsw}/${rname}"
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
  cwclean_${rname}
}
"
