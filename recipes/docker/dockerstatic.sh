rname="dockerstatic"
rver="20.10.15"
rdir="${rname//static/}-${rver}"
rbdir="${cwbuild}/docker"
rfile="${rdir}.tgz"
rreqs=""
rurl=""
rsha256=""
rburl="https://download.docker.com/linux/static/stable"
if [[ ${karch} =~ ^aarch64 ]] ; then
  rurl="${rburl}/aarch64/${rfile}"
  rsha256="46102273fab8d6b8a7cf248a928ebaa4bee43114001c593b0d07092a34a439e1"
elif [[ ${karch} =~ ^arm ]] ; then
  rurl="${rburl}/armhf/${rfile}"
  rsha256="bcad29339c1aa7c1d75eb3c016a2b3d1486220d693e5adbad637be63ecb23dc2"
elif [[ ${karch} =~ ^x86_64 ]] ; then
  rurl="${rburl}/x86_64/${rfile}"
  rsha256="9ccfc39305ae1d8882d18c9c431544fca82913d6df717409ac2244ac58c4f070"
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
