#
# XXX - need to separate downloads by arch, but that needs to be done in a function :\
# XXX - need to move all arch checking into functions for serializability
# XXX - pain
#
rname="dockerstatic"
rver="29.9.3"
rdir="${rname%static}-${rver}"
rbdir="${cwbuild}/docker"
rfile="${rdir}.tgz"
rreqs=""
rurl=""
rsha256=""
rburl="https://download.docker.com/linux/static/stable"
if [[ ${karch} =~ ^aarch64 ]] ; then
  rurl="${rburl}/aarch64/${rfile}"
  rsha256="1b27fd739378ef938401e81ce5afb73b7ad7432d4f598814a9ff5f826bb464d2"
  rreurl="${rurl%/*}/${rname%static}-rootless-extras-${rver}.tgz"
  rresha256="867bbb01a3df1566681ccf53da8255434d4ca2cc84a304111604b6ee6130c349"
elif [[ ${karch} =~ ^arm ]] ; then
  rurl="${rburl}/armhf/${rfile}"
  rsha256="946aa2687200ed7e63cc2481c2cb4f4bf1aff9b88a1abc74dbf70050a361fd64"
  rreurl="${rurl%/*}/${rname%static}-rootless-extras-${rver}.tgz"
  rresha256="90e919542d2d8d0dfc85688db60802be5cbe0639b3577ec61329123323e986f4"
elif [[ ${karch} =~ ^x86_64 ]] ; then
  rurl="${rburl}/x86_64/${rfile}"
  rsha256="3fb5d1f13014c18cc54945bc177c58a9056a482dada031e17d12cf2e6922c973"
  rreurl="${rurl%/*}/${rname%static}-rootless-extras-${rver}.tgz"
  rresha256="c41b7194dca722fe929bc0225fc87f3166c97e67d50a521533b0b23f3c79a466"
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
