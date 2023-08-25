#
# XXX - need a version policy, i.e. "within one version of k3s?"
# XXX - kubelet is glibc, probably need to compile? ugh?
# XXX - k8s builds seem relatively straightforward...
# XXX - gke vs upstream version skew can cause issues w/X.Y.Z clients against X.(Y-(3+)).Z clusters
# XXX - probably need to version, 1.25.x == kubernetes125, 1.26.x = kubernetes125, etc.
#
# dev doc:
#   https://github.com/kubernetes/community/blob/master/contributors/devel/development.md
#

rname="kubernetes"
rver="1.28.1"
rdir="${rname}-${rver}"
rfile=""
rreqs=""
rsha256=""
rurl="https://dl.k8s.io"

. "${cwrecipe}/common.sh"

if [[ ${karch} =~ ^(o|r) ]] ; then
  eval "
  function cwinstall_${rname}() {
    cwscriptecho \"${rname} does not support ${karch}\"
  }
  "
fi

cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwfetch_${rname}() {
  if [[ ${karch} =~ ^x86_64  ]] ; then a='amd64' ; fi
  if [[ ${karch} =~ ^arm     ]] ; then a='arm'   ; fi
  if [[ ${karch} =~ ^aarch64 ]] ; then a='arm64' ; fi
  if [[ ${karch} =~ ^i       ]] ; then a='386'   ; fi
  kubeprogs+=' apiextensions-apiserver '
  kubeprogs+=' kube-aggregator '
  kubeprogs+=' kube-apiserver '
  kubeprogs+=' kube-controller-manager '
  kubeprogs+=' kube-log-runner '
  kubeprogs+=' kube-proxy '
  kubeprogs+=' kube-scheduler '
  kubeprogs+=' kubeadm '
  kubeprogs+=' kubectl '
  kubeprogs+=' kubectl-convert '
  kubeprogs+=' kubelet '
  kubeprogs+=' mounter '
  if [[ \${a} =~ 386 ]] ; then kubeprogs='kubectl kubectl-convert' ; fi
  for k in \${kubeprogs} ; do
    u=\"${rurl}/v\$(cwver_${rname})/bin/linux/\${a}/\${k}\"
    f=\"${cwdl}/${rname}/\$(cwver_${rname})/\${a}/\${k}\"
    s=\"\${f}.sha256\"
    cwfetch \"\${u}.sha256\" \"\${s}\"
    cwfetchcheck \"\${u}\" \"\${f}\" \"\$(cat \${s})\"
  done
}
"

eval "
function cwmakeinstall_${rname}() {
  if [[ ${karch} =~ ^x86_64  ]] ; then a='amd64' ; fi
  if [[ ${karch} =~ ^arm     ]] ; then a='arm'   ; fi
  if [[ ${karch} =~ ^aarch64 ]] ; then a='arm64' ; fi
  if [[ ${karch} =~ ^i       ]] ; then a='386'   ; fi
  cwmkdir \"\$(cwidir_${rname})/bin\"
  for p in \$(find \"${cwdl}/${rname}/\$(cwver_${rname})/\${a}/\" -maxdepth 1 -mindepth 1 -type f) ; do
    if [[ \${p} =~ sha256\$ ]] ; then continue ; fi
    n=\"\$(basename \${p})\"
    install -m 0755 \"\${p}\" \"\$(cwidir_${rname})/bin/\${n}\"
  done
}
"

eval "
function cwlatestver_${rname}() {
  ${cwcurl} ${cwcurlopts} \"https://storage.googleapis.com/kubernetes-release/release/stable.txt\" | sed s/^v// | xargs echo
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
