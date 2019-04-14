rname="go"
rver="1.12.4"
if [[ ${karch} =~ ^x86_64$ ]] ; then
	rdir="${rname}${rver}-amd64"
	rsha256="4abbed28884a6391dd9736ca7adeecdfcb45ecba9e025dcad0307d84e0e47afb"
elif [[ ${karch} =~ ^i.86$ ]] ; then
	rdir="${rname}${rver}-386"
	rsha256="49d776192036e1c3461f5807caa4689519fce87e646378f46437e5bcd97f4c44"
elif [[ ${karch} =~ ^aarch64 ]] ; then
	rdir="${rname}${rver}-arm64"
	rsha256="a61d5636cafd80f25e2619cf9e6a563b27dcb067f4fae3d0a1ac522d42c788d3"
elif [[ ${karch} =~ ^arm ]] ; then
	rdir="${rname}${rver}-arm"
	rsha256="e306084f4bed717e80aa0ba5a3c21676f027da049d15c07dbafb0fb4ef83297e"
fi
rfile="${rdir}.tar.gz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/20190414/${rfile}"
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
