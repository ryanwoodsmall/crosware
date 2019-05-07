rname="dockerstatic"
rver="18.09.6"
rdir="${rname//static/}-${rver}"
rbdir="${cwbuild}/docker"
rfile="${rdir}.tgz"
rreqs=""
rurl=""
rsha256=""
rburl="https://download.docker.com/linux/static/stable"
if [[ ${karch} =~ ^aarch64 ]] ; then
  rurl="${rburl}/aarch64/${rfile}"
  rsha256="c4857639514471e2d1aa6d567880b7fc226437ede462021ed44157d4dcd11dc8"
elif [[ ${karch} =~ ^arm ]] ; then
  rurl="${rburl}/armhf/${rfile}"
  rsha256="030660a6a7c3fbab53079f27c8f4c904c9231b19f0e3693376022777adbd6dfd"
elif [[ ${karch} =~ ^x86_64 ]] ; then
  rurl="${rburl}/x86_64/${rfile}"
  rsha256="1f3f6774117765279fce64ee7f76abbb5f260264548cf80631d68fb2d795bb09"
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
