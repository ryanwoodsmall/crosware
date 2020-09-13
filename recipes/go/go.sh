#
# XXX - rename to "gostatic"
# XXX - requires go-misc change too
# XXX - generic go recipe w/CGO enabled
# XXX - date should be moved to version?
#

rname="go"
rver="1.15.2"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="${rname}${rver}-amd64"
  rsha256="9bbe15759245a57f96194b065fa95c041517f9c4a7ae018806681805e6a01118"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="${rname}${rver}-386"
  rsha256="b02ebf806e85d783cf6061a682d92f6a2ecb82b118b261cbb00972b685b19843"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="${rname}${rver}-arm64"
  rsha256="d4ac933bed414e7fa5037f8053ebec9723a06df1f85badcf701d15ea672016d6"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="${rname}${rver}-arm"
  rsha256="e00a69622b161c9281cb4b4e0c2d2901d0bab4dd7be7346558e735e565925401"
fi
rfile="${rdir}.tar.bz2"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/20200912-${rname}${rver}/${rfile}"
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
