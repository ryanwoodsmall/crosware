rname="go"
rver="1.12.5"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="${rname}${rver}-amd64"
  rsha256="14f18ec7e678c9a7db4996324439005d2e1ebec75e18cb1808a6a8a194a9e5e5"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="${rname}${rver}-386"
  rsha256="01112c8603c13f666cb15e70dcacab9ac6db3677bec8a25ca2a479f843d8bc02"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="${rname}${rver}-arm64"
  rsha256="fde5fd9d0fe7cd26d42287f1518cc5717c3095bc362c8edad2b0c076bd855f86"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="${rname}${rver}-arm"
  rsha256="d8fcee8f2e3bdcc74d12e1a150dbd7bedeaa65765dc2352d0c9659b907d6b8b8"
fi
rfile="${rdir}.tar.gz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/20190511/${rfile}"
rreqs=""

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

eval "
function cwextract_${rname}() {
  cwextract \"${cwdl}/${rname}/${rfile}\" \"${rtdir}\"
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwsourceprofile
  cwextract_${rname}
  cwlinkdir_${rname}
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"
