#
# XXX - ONLY upstream kubectl
# XXX - this is ALWAYS latest, explicitly unversioned, must manually update
# XXX - move to go build? hmm. not rn
#
rname="kubectllatest"
rver="latest"
rdir="${rname}"
rfile=""
rurl="https://www.downloadkubernetes.com"
rsha256=""
rreqs=""

. "${cwrecipe}/common.sh"

cwstubfunc "cwclean_${rname}"
cwstubfunc "cwfetch_${rname}"
cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}() {
  local v=\"\$(\${cwcurl} \${cwcurlopts} https://dl.k8s.io/release/stable.txt)\"
  local a=none
  local u=none
  local s=none
  if [[ \${karch} =~ ^x86_64  ]] ; then a='amd64' ; fi
  if [[ \${karch} =~ ^arm     ]] ; then a='arm'   ; fi
  if [[ \${karch} =~ ^aarch64 ]] ; then a='arm64' ; fi
  if [[ \${karch} =~ ^i       ]] ; then a='386'   ; fi
  if [[ \${a} =~ none ]] ; then cwfailexit \"arch \${karch} not supported\" ; fi
  u=\"https://dl.k8s.io/\${v}/bin/linux/\${a}/kubectl\"
  s=\"\$(\${cwcurl} \${cwcurlopts} \${u}.sha256 | awk '{print \$1}')\"
  cwmkdir \"\$(cwidir_${rname})/bin\"
  cwfetchcheck \"\${u}\" \"\$(cwidir_${rname})/bin/kubectl\" \"\${s}\"
  chmod 755 \"\$(cwidir_${rname})/bin/kubectl\"
  ln -sf kubectl \"\$(cwidir_${rname})/bin/${rname}\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
