: ${rbdir:="${cwbuild}/${rdir}"}
: ${rtdir:="${cwsw}/${rname}"}
: ${ridir:="${rtdir}/${rdir}"}
: ${rprof:="${cwetcprofd}/${rname}.sh"}
: ${rreqs:=""}

cwconfigureprefix="--prefix=${ridir}"
cwconfigurelibopts="--enable-static --enable-static=yes --disable-shared --enable-shared=no"
cwconfigurefpicopts="CFLAGS=\"\${CFLAGS} -fPIC\" CXXFLAGS=\"\${CXXFLAGS} -fPIC\""

eval "
function cwname_${rname}() {
  echo "${rname}"
}
"

eval "
function cwver_${rname}() {
  echo "${rver}"
}
"

eval "
function cwclean_${rname}() {
  pushd "${cwbuild}" >/dev/null 2>&1
  rm -rf "${rdir}"
  popd >/dev/null 2>&1
}
"

eval "
function cwfetch_${rname}() {
  cwfetchcheck "${rurl}" "${cwdl}/${rname}/${rfile}" "${rsha256}"
}
"

eval "
function cwcheckreqs_${rname}() {
  for rreq in ${rreqs} ; do
    if ! \$(cwcheckinstalled \${rreq}) ; then
      cwinstall_\${rreq}
      cwsourceprofile
    fi
  done
}
"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix}
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make -j${cwmakejobs}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
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
function cwextract_${rname}() {
  cwextract "${cwdl}/${rname}/${rfile}" "${cwbuild}"
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwcheckreqs_${rname}
  cwsourceprofile
  cwclean_${rname}
  cwextract_${rname}
  cwconfigure_${rname}
  cwmake_${rname}
  cwmakeinstall_${rname}
  cwlinkdir "${rdir}" "${rtdir}"
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
  cwclean_${rname}
}
"

eval "
function cwuninstall_${rname}() {
  pushd "${cwsw}" >/dev/null 2>&1
  rm -rf "${rname}"
  rm -f "${rprof}"
  rm -f "${cwvarinst}/${rname}"
  popd >/dev/null 2>&1
}
"
