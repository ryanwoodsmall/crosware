#
# XXX - no checksums yet! use at your own risk!
# XXX - skipping dropbear scp for now since $PATH to dbclient is hard-coded
#
rname="cwstaticbinaries"
rver="228c67d1a9e56cf84c41bde3a70734e857c17cb4"
rdir="${rname}-${rver}"
rfile=""
rurl="https://github.com/ryanwoodsmall/static-binaries"
rsha256=""
rreqs=""
# make these fallbacks to the fallbacks
rprof="${cwetcprofd}/zz_zz_${rname}.sh"

. "${cwrecipe}/common.sh"

cwstubfunc "cwclean_${rname}"
cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwfetch_${rname}() {
  local a=''
  local p=''
  local u=''
  local i=''
  local f=''
  : \${bu:=''}
  if [ -z \"\${bu}\" ] ; then
    bu=\"${rurl}/raw/\$(cwver_${rname})\"
  fi
  if [[ \${karch} =~ ^aarch64 ]] ; then a='aarch64' ; fi
  if [[ \${karch} =~ ^arm     ]] ; then a='armhf'   ; fi
  if [[ \${karch} =~ ^i       ]] ; then a='i686'    ; fi
  if [[ \${karch} =~ ^riscv64 ]] ; then a='riscv64' ; fi
  if [[ \${karch} =~ ^x86_64  ]] ; then a='x86_64'  ; fi
  if [ -z \"\${a}\" ] ; then
    cwfailexit \"${rname} not supported on \$(uname -m)\"
  fi
  if command -v curl &>/dev/null ; then
    f=cwfetch
  else
    f=\"${cwtop}/scripts/fakecurl.sh\"
  fi
  cwmkdir \"\$(cwidir_${rname})/bin\"
  for p in ag bash brssl busybox curl dash dropbearmulti entr jo jq less links make mandoc mk mksh neatvi nc pv px5g rc rlwrap rsync sbase-box screen socat stunnel tini tmux toybox ubase-box unrar x509cert xz ; do
    u=\"\${bu}/\${a}/\${p}\"
    \${f} \"\${u}\" \"\$(cwidir_${rname})/bin/\${p}\"
    chmod 755 \"\$(cwidir_${rname})/bin/\${p}\"
  done
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwidir_${rname})/bin\" &>/dev/null
  local i=''
  local l=''
  local p=''
  for i in \$(./busybox --list) ; do
    test -e \${i} || ln -s busybox \${i}
  done
  for p in toybox sbase-box ubase-box ; do
    for i in \$(./\${p}) ; do
      test -e \${i} || ln -s \${p} \${i}
    done
  done
  for i in dbclient dropbear dropbearconvert dropbearkey ssh ; do
    test -e \${i} || ln -s dropbearmulti \${i}
  done
  for l in crosware musl ; do
    for p in busybox toybox ; do
      ln -sf ${rtdir}/current/bin/\${p} \$(cwidir_${rname})/bin/\${p}.\${l}
    done
  done
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
