#
# XXX - rename to "gostatic"
# XXX - requires go-misc change too
# XXX - generic go recipe w/CGO enabled
# XXX - date should be moved to version?
#

rname="go"
rver="1.15.10"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="${rname}${rver}-amd64"
  rsha256="a2269fe394bcb14c9275d6d81c48471078459a99f6752ce401069ccde90b32a6"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="${rname}${rver}-386"
  rsha256="6989ce738f8d01ae966f5681d1340bb0464dae26633bde06cd8a6ca9114f06ec"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="${rname}${rver}-arm64"
  rsha256="a1b2becaa643e96fe98a76221479a8f775ff6fd7bbbcb9b4c8825a82ebdecac1"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="${rname}${rver}-arm"
  rsha256="5ba6991c8c10a29e7d8de0bd08e51ea1e5b90544956851872f0326baef532ffd"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="${rname}${rver}-riscv64"
  rsha256="b9c715395d50fe4f86cc21f5a4740b75245d481118b3bc544fcf060313a92f12"
else
  rdir="none"
  rsha256="none"
fi
rfile="${rdir}.tar.bz2"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/20210317-${rname}${rver}/${rfile}"
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
