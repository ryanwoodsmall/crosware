rprof="${cwetcprofd}/${rname}.sh"

eval "
function cwclean_${rname}() {
  pushd "${cwbuild}" >/dev/null 2>&1
  rm -rf "${rdir}"
  popd >/dev/null 2>&1
}
"

eval "
function cwfetch_${rname}() {
  cwfetchcheck "${rurl}" "${cwdl}/${rfile}" "${rsha256}"
}
"

eval "
function cwconfigure_${rname}() {
  pushd "${cwbuild}/${rdir}" >/dev/null 2>&1
  ./configure --prefix="${cwsw}/${rname}/${rdir}"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd "${cwbuild}/${rdir}" >/dev/null 2>&1
  make -j$(($(nproc)+1))
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${cwbuild}/${rdir}" >/dev/null 2>&1
  make install
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo "\\\# ${rname}" > "${rprof}"
}
"

eval "
function cwmarkinstall_${rname}() {
  cwmarkinstall "${rname}" "${rver}"
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwclean_${rname}
  cwextract "${cwdl}/${rfile}" "${cwbuild}"
  cwconfigure_${rname}
  cwmake_${rname}
  cwmakeinstall_${rname}
  cwlinkdir "${rdir}" "${cwsw}/${rname}"
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
  cwclean_${rname}
}
"
