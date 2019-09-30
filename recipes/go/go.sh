#
# XXX - rename to "gostatic"
# XXX - requires go-misc change too
# XXX - generic go recipe w/CGO enabled
#

rname="go"
rver="1.13.1"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="${rname}${rver}-amd64"
  rsha256="bfcf43e935cab3a5548a10fba85037ba6aa0ad11a0bbbd74b5791cd4ccb8d8ee"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="${rname}${rver}-386"
  rsha256="cff4ff2a3ff211c2bc53ef56d8650a311d4468a4a937857d9691bbdd09df3f62"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="${rname}${rver}-arm64"
  rsha256="c0232b46ed206dc4d3c408112e8b255c73b1463e84fd978373910efb2b059ff7"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="${rname}${rver}-arm"
  rsha256="e7de1c12fd2cd4c4f4f8ad3c29a035ee4d65386036503260115f5262ccdda94a"
fi
rfile="${rdir}.tar.bz2"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/20190929-${rname}${rver}/${rfile}"
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
