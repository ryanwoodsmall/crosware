# XXX - add an associative array of rver/rreqs
# XXX - rbdir should include /${rname}/ - what will it break? not much...
: ${rbdir:="${cwbuild}/${rdir}"}
: ${rtdir:="${cwsw}/${rname}"}
: ${ridir:="${rtdir}/${rdir}"}
: ${rprof:="${cwetcprofd}/${rname}.sh"}
: ${rdlfile:="${cwdl}/${rname}/${rfile}"}
: ${rreqs:=""}
: ${rlibtool:=""}
: ${rconfigureopts:=""}
: ${rcommonopts:=""}
: ${rurl:=""}

if [[ ${rlibtool} == "" && ${rreqs} =~ slibtool ]] ; then
  rlibtool="LIBTOOL='${cwsw}/slibtool/current/bin/slibtool-static -all-static'"
fi

cwconfigureprefix="--prefix=${ridir}"
cwconfigurelibopts="--enable-static --enable-static=yes --disable-shared --enable-shared=no"
cwconfigurefpicopts="CFLAGS=\"\${CFLAGS} -fPIC\" CXXFLAGS=\"\${CXXFLAGS} -fPIC\""

eval "
function cwname_${rname}() {
  echo \"${rname}\"
}
"

eval "
function cwfile_${rname}() {
  echo \"${rfile}\"
}
"

eval "
function cwdlfile_${rname}() {
  echo \"${rdlfile}\"
}
"

eval "
function cwdir_${rname}() {
  echo \"${rdir}\"
}
"

eval "
function cwver_${rname}() {
  echo \"${rver}\"
}
"

eval "
function cwurl_${rname}() {
  echo \"${rurl}\"
}
"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  rm -rf \"${rbdir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
}
"

eval "
function cwlistreqs_${rname}() {
  echo \"${rreqs}\"
}
"

eval "
function cwcheckreqs_${rname}() {
  cwcheckuniq \"\${FUNCNAME[@]}\"
  for rreq in ${rreqs} ; do
    if ! \$(cwcheckinstalled \${rreq}) ; then
      cwscriptecho \"installing required recipe \${rreq}\"
      cwinstall_\${rreq}
      cwsourceprofile
    fi
  done
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts}
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} ${rlibtool}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo '# ${rname}' > \"${rprof}\"
}
"

eval "
function cwmarkinstall_${rname}() {
  cwmarkinstall \"${rname}\" \"${rver}\"
}
"

eval "
function cwextract_${rname}() {
  cwextract \"${rdlfile}\" \"${cwbuild}\"
}
"

eval "
function cwlinkdir_${rname}() {
  cwlinkdir \"$(basename ${ridir})\" \"${rtdir}\"
}
"

# XXX - noop for now
eval "
function cwpatch_${rname}() {
  true
}
"

eval "
function cwfetchpatches_${rname}() {
  true
}
"

eval "
function cwinstall_${rname}() {
  cwcheckuniq \"\${FUNCNAME[@]}\"
  cwclean_${rname}
  cwfetch_${rname}
  cwcheckreqs_${rname}
  cwsourceprofile
  cwextract_${rname}
  cwconfigure_${rname}
  cwmake_${rname}
  cwmakeinstall_${rname}
  cwlinkdir_${rname}
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
  cwclean_${rname}
}
"

eval "
function cwuninstall_${rname}() {
  pushd \"${cwsw}\" >/dev/null 2>&1
  rm -rf \"${rname}\"
  rm -f \"${rprof}\"
  rm -f \"${cwvarinst}/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwupgrade_${rname}() {
  cwuninstall_${rname}
  cwinstall_${rname}
}
"
