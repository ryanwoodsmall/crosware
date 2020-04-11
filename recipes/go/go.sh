#
# XXX - rename to "gostatic"
# XXX - requires go-misc change too
# XXX - generic go recipe w/CGO enabled
#

rname="go"
rver="1.14.2"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="${rname}${rver}-amd64"
  rsha256="ded4cc7eb90faa2265d4bb20d07449eb0b2ade30c7c45b429ec81ada11b1abdf"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="${rname}${rver}-386"
  rsha256="dfe1fe12b5955ff71cdbec45aeed6d191bbdf3cdaaabc863359de3769abbc150"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="${rname}${rver}-arm64"
  rsha256="2d91bd23d489fee23c838ac59632e6e90c8f33982edcc122fc596c01bd288c1e"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="${rname}${rver}-arm"
  rsha256="5840bc85bc8cdfbdf5eae5638735e78527f474e09daa5afa9c15e025df92536e"
fi
rfile="${rdir}.tar.bz2"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/20200410-${rname}${rver}/${rfile}"
rreqs=""

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

eval "
function cwextract_${rname}() {
  cwextract \"${rdlfile}\" \"${rtdir}\"
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
