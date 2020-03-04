rname="dockerstatic"
rver="19.03.7"
rdir="${rname//static/}-${rver}"
rbdir="${cwbuild}/docker"
rfile="${rdir}.tgz"
rreqs=""
rurl=""
rsha256=""
rburl="https://download.docker.com/linux/static/stable"
if [[ ${karch} =~ ^aarch64 ]] ; then
  rurl="${rburl}/aarch64/${rfile}"
  rsha256="730058a50102dbf9278e5d164c385a437016c8c8201d6d19195d9321d0a70ec9"
elif [[ ${karch} =~ ^arm ]] ; then
  rurl="${rburl}/armhf/${rfile}"
  rsha256="7090e4ea505441e076736d43515f8e2808c32ebb2221b46327ee202fd4997d84"
elif [[ ${karch} =~ ^x86_64 ]] ; then
  rurl="${rburl}/x86_64/${rfile}"
  rsha256="033e97ae6b31e21c598fd089ea034c08d75dc744ceb787898d63dfc4e45ead03"
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
  if [[ ${karch} =~ ^i.86 ]] ; then
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
