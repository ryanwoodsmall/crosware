#
# XXX - rename to "gostatic"
# XXX - requires go-misc change too
# XXX - generic go recipe w/CGO enabled
# XXX - date should be moved to version?
#

rname="go"
rver="1.15.4"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="${rname}${rver}-amd64"
  rsha256="4b9a365e8673f210ea6e53aa8b5e53b261a4a1a7ed60bc7dd592cec33c3ffde9"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="${rname}${rver}-386"
  rsha256="b2f9041d79ffd001c65aac43f78c2b2dfdbe0d0a1c2f0a90276e5e60555393f2"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="${rname}${rver}-arm64"
  rsha256="bc422d7550a653447bbf3af1a6981d9d09300f9628f89871c46f0588e26eeef4"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="${rname}${rver}-arm"
  rsha256="3aed436490cbd7e98a18316eb812851fd8f678eb4e923f80aa627febbfbd611c"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="${rname}${rver}-riscv64"
  rsha256="c41c1dab8ef2aa5803b2858540ac297d681f6dec7a2be5bb94cdda695f1085c2"
else
  rdir="none"
  rsha256="none"
fi
rfile="${rdir}.tar.bz2"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/20201107-${rname}${rver}/${rfile}"
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
