rname="go"
rver="1.12.1"
if [[ ${karch} =~ ^x86_64$ ]] ; then
	rdir="${rname}${rver}-amd64"
	rsha256="cd1a30e940a055e1ed5bc9f9993fc46907b98c771af28aa797ff5629355f0539"
elif [[ ${karch} =~ ^i.86$ ]] ; then
	rdir="${rname}${rver}-386"
	rsha256="919cf4b7fc91a52fd31c6f5c370056ef7b9eb10bfa0fcb4e6a677c23d9e2bbb9"
elif [[ ${karch} =~ ^aarch64 ]] ; then
	rdir="${rname}${rver}-arm64"
	rsha256="32f8389d7a81b6bcee2a8403f4d8bb94a83f9046c9a5443f797de67db1444fcd"
elif [[ ${karch} =~ ^arm ]] ; then
	rdir="${rname}${rver}-arm"
	rsha256="0dd51e4ebdc0cc7cf0a333bccd881f4234c2127b5fe4d3363719fb75f684708e"
fi
rfile="${rdir}.tar.gz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/20190316/${rfile}"
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
