#
# XXX - need to separate downloads by arch, but that needs to be done in a function :\
# XXX - need to move all arch checking into functions for serializability
# XXX - pain
#
rname="dockerstatic"
rver="29.8.2"
rdir="${rname%static}-${rver}"
rbdir="${cwbuild}/docker"
rfile="${rdir}.tgz"
rreqs=""
rurl=""
rsha256=""
rburl="https://download.docker.com/linux/static/stable"
if [[ ${karch} =~ ^aarch64 ]] ; then
  rurl="${rburl}/aarch64/${rfile}"
  rsha256="76a624e4a8e5da654d1150e808175125efb5a6f1b6aa1cbd9caee18f51047a50"
  rreurl="${rurl%/*}/${rname%static}-rootless-extras-${rver}.tgz"
  rresha256="f8f759dfeecb5bbe2c963232a1b9380e133f677dc0579263e4ca04c69f40aa47"
elif [[ ${karch} =~ ^arm ]] ; then
  rurl="${rburl}/armhf/${rfile}"
  rsha256="ca973022fed39c5944dc72046b95e0e925d94f29ca78983a164e9126214a2e29"
  rreurl="${rurl%/*}/${rname%static}-rootless-extras-${rver}.tgz"
  rresha256="f60b5e1d43d3231dc25ddb1c474c03774dbb6d54ada97051f20a7e314bab8887"
elif [[ ${karch} =~ ^x86_64 ]] ; then
  rurl="${rburl}/x86_64/${rfile}"
  rsha256="995d1ef289677f74fd58d8d2c35727b6a4ee389c69db8638a3e42d0487aa5b0f"
  rreurl="${rurl%/*}/${rname%static}-rootless-extras-${rver}.tgz"
  rresha256="707ebf6a5afd88104086e7b6749997b2366e816aeaf2c3ef2305b08fde9ee007"
fi
unset rburl

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

cwappendfunc "cwfetch_${rname}" "cwfetchcheck \"${rreurl}\" \"${cwdl}/${rname}/${rname%static}-rootless-extras-${rver}.tgz\" \"${rresha256}\""

unset rreurl
unset rresha256

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  local p
  find . -mindepth 1 -maxdepth 1 -type f | while read -r p ; do install -m 0755 \"\${p}\" \"\$(cwidir_${rname})/bin/\" ; done
  unset p
  cwextract \"\$(cwdlfile_${rname} | sed s,/docker-\$(cwver_${rname}),/docker-rootless-extras-\$(cwver_${rname}),g)\" \"\$(cwidir_${rname})\"
  popd &>/dev/null
}
"

cwcopyfunc "cwinstall_${rname}" "cwinstall_${rname}_real"
eval "
function cwinstall_${rname}() {
  if [[ \${karch} =~ ^(i.86|riscv64) ]] ; then
    cwscriptecho \"${rname} does not support \${karch}\"
    return
  fi
  cwinstall_${rname}_real
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"

# vim: set ft=bash:
