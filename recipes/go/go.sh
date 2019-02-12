rname="go"
rver="1.11.5"
if [[ ${karch} =~ ^x86_64$ ]] ; then
	rdir="${rname}${rver}-amd64"
	rsha256="4a03d25c1d8a277bdd877e8b8f3b934ca438449403a23011d2d9ef2cfddd15a5"
elif [[ ${karch} =~ ^i.86$ ]] ; then
	rdir="${rname}${rver}-386"
	rsha256="9bd2488c72f0d1a0cec103e92fe2d2669924beaa2c83f9efe8f3553f7436dd21"
elif [[ ${karch} =~ ^aarch64 ]] ; then
	rdir="${rname}${rver}-arm64"
	rsha256="27fc6c29e94a48d117c710d26386c599f45dee4a48b6ce0854517af682ce75de"
elif [[ ${karch} =~ ^arm ]] ; then
	rdir="${rname}${rver}-arm"
	rsha256="258173e130a2f471b93541ecdeab3ed16383470ddca8fd0c9f600fdf40cb314a"
fi
rfile="${rdir}.tar.gz"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/20190212/${rfile}"
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
