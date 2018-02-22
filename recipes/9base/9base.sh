rfile=""
rsha256=""
rname="9base"
rver="09e95a2"
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
  grep -ril /usr/local/plan9 . \
  | grep -v '\.git' \
  | xargs sed -i "s#/usr/local/plan9#${cwsw}/${rname}/${rdir}#g"
  sed -i '/^PREFIX/d' config.mk
  sed -i '/^CC/d' config.mk
  echo "CC = \${CC}" >> config.mk
  echo "PREFIX = ${cwsw}/${rname}/${rdir}" >> config.mk
  if [[ $(uname -m) =~ x86_64 ]] ; then
    sed -i '/^OBJTYPE/d' config.mk
    echo "OBJTYPE = x86_64" >> config.mk
  elif [[ $(uname -m) =~ a(arch|rm) ]] ; then
    sed -i '/^OBJTYPE/d' config.mk
    echo "OBJTYPE = arm" >> config.mk
  fi
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'export PLAN9=\"${cwsw}/${rname}/current\"' > "${rprof}"
  echo 'append_path \"\${PLAN9}/bin\"' >> "${rprof}"
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
