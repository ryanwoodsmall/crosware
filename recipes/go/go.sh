#
# XXX - rename to "gostatic"
# XXX - requires go-misc change too
# XXX - generic go recipe w/CGO enabled
# XXX - date should be moved to version?
#

rname="go"
rver="1.15"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="${rname}${rver}-amd64"
  rsha256="0992f139f881a42469ce39c5dcd68163bc10c15dd7f2f976caa3a84aad258549"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="${rname}${rver}-386"
  rsha256="43d35a5de5e3d957e95cadc617379c9cc64989fb2b7e4927ce918eb96ff85d30"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="${rname}${rver}-arm64"
  rsha256="35c740ce794ed55687c4cedf34733482757bb6a6d0dd2278a044fa9268b66bae"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="${rname}${rver}-arm"
  rsha256="e1100711434ae46947a67dac1681261844044f2459ffa247e2315427baec5df9"
fi
rfile="${rdir}.tar.bz2"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/20200815-${rname}${rver}/${rfile}"
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
