rname="dockerstatic"
rver="25.0.4"
rdir="${rname//static/}-${rver}"
rbdir="${cwbuild}/docker"
rfile="${rdir}.tgz"
rreqs=""
rurl=""
rsha256=""
rburl="https://download.docker.com/linux/static/stable"
if [[ ${karch} =~ ^aarch64 ]] ; then
  rurl="${rburl}/aarch64/${rfile}"
  rsha256="ce7b2ffb522cde59f2bb4b67a17db4aaf66b058532effcd583ab85d02ede529f"
elif [[ ${karch} =~ ^arm ]] ; then
  rurl="${rburl}/armhf/${rfile}"
  rsha256="2bdda6dfd7f1bd60740c954015e6f516bbfacfd33239239b5185041ab61047e9"
elif [[ ${karch} =~ ^x86_64 ]] ; then
  rurl="${rburl}/x86_64/${rfile}"
  rsha256="23db817b99aac6d5d7fcb1f706e50b5a412d78a9438975d6b4a54c58dc409bfb"
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
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  mkdir -p \"\$(cwidir_${rname})/bin\"
  local p
  find . -mindepth 1 -maxdepth 1 -type f | while read -r p ; do install -m 0755 \"\${p}\" \"\$(cwidir_${rname})/bin/\" ; done
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
