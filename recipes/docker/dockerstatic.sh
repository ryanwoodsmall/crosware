rname="dockerstatic"
rver="29.0.2"
rdir="${rname//static/}-${rver}"
rbdir="${cwbuild}/docker"
rfile="${rdir}.tgz"
rreqs=""
rurl=""
rsha256=""
rburl="https://download.docker.com/linux/static/stable"
if [[ ${karch} =~ ^aarch64 ]] ; then
  rurl="${rburl}/aarch64/${rfile}"
  rsha256="ee2507268dc15345b5dc132e8246e0f29f2d629cf8cebb966e2a2008418b7d76"
elif [[ ${karch} =~ ^arm ]] ; then
  rurl="${rburl}/armhf/${rfile}"
  rsha256="d939cf93c98466fde45af6c2770825fd233d911cbd7e533d30b17cef9e121dcf"
elif [[ ${karch} =~ ^x86_64 ]] ; then
  rurl="${rburl}/x86_64/${rfile}"
  rsha256="079e491e942e7a7a090c593db7eb63f3d657b5ca166c38dab59678b165b91eca"
fi
unset rburl

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  local p
  find . -mindepth 1 -maxdepth 1 -type f | while read -r p ; do install -m 0755 \"\${p}\" \"\$(cwidir_${rname})/bin/\" ; done
  unset p
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
