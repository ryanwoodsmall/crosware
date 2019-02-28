rname="go"
rver="1.12"
if [[ ${karch} =~ ^x86_64$ ]] ; then
	rdir="${rname}${rver}-amd64"
	rsha256="fc9f87cdc38645ab8c6c516cb28afb07016f48c69f170d4ca4578cce170ba432"
elif [[ ${karch} =~ ^i.86$ ]] ; then
	rdir="${rname}${rver}-386"
	rsha256="97179f204eb3ff0edd44f7dfc1dbc134dae43c0a6d856edf79cae5a836e157c7"
elif [[ ${karch} =~ ^aarch64 ]] ; then
	rdir="${rname}${rver}-arm64"
	rsha256="14e07a48af7fd1c4e89cb3e2fbe3c9c6302432740b7cf80574fe1f19cf845ad5"
elif [[ ${karch} =~ ^arm ]] ; then
	rdir="${rname}${rver}-arm"
	rsha256="a79217a2d23570f0ec70bef1076b9ef60ab6dbbefc084a5c4d42f69916ec3ccc"
fi
rfile="${rdir}.tar.gz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/20190227/${rfile}"
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
