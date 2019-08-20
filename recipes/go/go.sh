rname="go"
rver="1.12.9"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="${rname}${rver}-amd64"
  rsha256="6bbdefb47965870ba66b216b159b775861591f9a8104fe4d063e46185fc1cc87"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="${rname}${rver}-386"
  rsha256="3c9dbcea178b2d00b5609a6275b1204cf59e26f62bb9b67a0209782c23d83e9c"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="${rname}${rver}-arm64"
  rsha256="9b44669acc5b07e7665f2c641a00dd5eefba4a81c6f74bd539c1b319b247d168"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="${rname}${rver}-arm"
  rsha256="6dd3279cea9c2025465602ead0eea16db48e8ecd56f9c8e3100ac1136ef4db38"
fi
rfile="${rdir}.tar.gz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/20190819-go${rver}/${rfile}"
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
