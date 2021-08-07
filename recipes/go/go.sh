#
# XXX - rename to "gostatic"
# XXX - requires go-misc change too
# XXX - generic go recipe w/CGO enabled
# XXX - date should be moved to version?
#

rname="go"
rver="1.16.7"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="${rname}${rver}-amd64"
  rsha256="0fd964ec9b12dd9a753ce5263e0cf298445b9034d7416b46a11e187a69b4af0d"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="${rname}${rver}-386"
  rsha256="ade3a7c1bebb0e3ddff36250d342e486ffd0c3c12f7a9433e40d413ac5c94be4"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="${rname}${rver}-arm64"
  rsha256="993e3e4f3fce7eac7a021c6aee22c557d8bd2551d40ff9e0f1438bfb4ad9f162"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="${rname}${rver}-arm"
  rsha256="2b2ca9936b61ad06fee65df5035f4730fd7e29b1595466edcc2a30c0363c3b45"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="${rname}${rver}-riscv64"
  rsha256="5e9d9ba966f32fa6eab44111cf7669b545a8457e80ec65898b0734674742d697"
else
  rdir="none"
  rsha256="none"
fi
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/20210806-${rname}${rver}/${rfile}"
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
