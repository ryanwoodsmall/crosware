rname="dockerstatic"
rver="20.10.10"
rdir="${rname//static/}-${rver}"
rbdir="${cwbuild}/docker"
rfile="${rdir}.tgz"
rreqs=""
rurl=""
rsha256=""
rburl="https://download.docker.com/linux/static/stable"
if [[ ${karch} =~ ^aarch64 ]] ; then
  rurl="${rburl}/aarch64/${rfile}"
  rsha256="8db47cdcd7ac6e082c9ce83347d8fb99eaa01e04b0c8d94851e8d58f350a3633"
elif [[ ${karch} =~ ^arm ]] ; then
  rurl="${rburl}/armhf/${rfile}"
  rsha256="7d4b4136789b63c476820670255eee450ada1ded07ab3f871388bf1ddb2a06c5"
elif [[ ${karch} =~ ^x86_64 ]] ; then
  rurl="${rburl}/x86_64/${rfile}"
  rsha256="1719446f99cd56e87d0c67019996af4ea859f11891bfd89de2252d6c916ccaaa"
fi
unset rburl

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  mkdir -p \"${ridir}/bin\"
  local p
  find . -mindepth 1 -maxdepth 1 -type f | while read -r p ; do install -m 0755 \"\${p}\" \"${ridir}/bin/\" ; done
  unset p
  popd >/dev/null 2>&1
}
"

eval "
function cwinstall_${rname}() {
  if [[ ${karch} =~ ^(i.86|riscv64) ]] ; then
    cwscriptecho \"${rname} does not support ${karch}\"
    return
  fi
  cwclean_${rname}
  cwfetch_${rname}
  cwcheckreqs_${rname}
  cwsourceprofile
  cwextract_${rname}
  cwmakeinstall_${rname}
  cwlinkdir_${rname}
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
  cwclean_${rname}
}
"
