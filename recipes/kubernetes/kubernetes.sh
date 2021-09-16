#
# XXX - need a version policy, i.e. "within one version of k3s?"
# XXX - kubelet is glibc, probably need to compile? ugh?
# XXX - k8s builds seem relatively straightforward...
#
# dev doc:
#   https://github.com/kubernetes/community/blob/master/contributors/devel/development.md
#

rname="kubernetes"
rver="1.21.5"
rdir="${rname}-${rver}"
rfile=""
rreqs=""
rsha256=""
rurl=""

. "${cwrecipe}/common.sh"

if [[ ${karch} =~ ^(o|r) ]] ; then
  eval "
  function cwinstall_${rname}() {
    cwscriptecho \"${rname} does not support ${karch}\"
  }
  "
fi

for f in extract configure make ; do
  eval "
  function cw${f}_${rname}() {
    true
  }
  "
done
unset f

rburl="https://dl.k8s.io/v${rver}/bin/linux"
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
  kubeprogs+=' kube-proxy '
  kubeprogs+=' kube-scheduler '
  kubeprogs+=' kubeadm '
  kubeprogs+=' kubectl '
  kubeprogs+=' kubectl-convert '
  kubeprogs+=' kubelet '
  kubeprogs+=' mounter '
  if [[ \${a} =~ 386 ]] ; then kubeprogs='kubectl kubectl-convert' ; fi
  for k in \${kubeprogs} ; do
    u=\"${rburl}/\${a}/\${k}\"
    f=\"${cwdl}/${rname}/${rver}/\${a}/\${k}\"
    s=\"\${f}.sha256\"
    cwfetch \"\${u}.sha256\" \"\${s}\"
    cwfetchcheck \"\${u}\" \"\${f}\" \"\$(cat \${s})\"
  done
}
"
unset rburl

eval "
function cwmakeinstall_${rname}() {
  if [[ ${karch} =~ ^x86_64  ]] ; then a='amd64' ; fi
  if [[ ${karch} =~ ^arm     ]] ; then a='arm'   ; fi
  if [[ ${karch} =~ ^aarch64 ]] ; then a='arm64' ; fi
  if [[ ${karch} =~ ^i       ]] ; then a='386'   ; fi
  cwmkdir \"${ridir}/bin\"
  for p in \$(find \"${cwdl}/${rname}/${rver}/\${a}/\" -maxdepth 1 -mindepth 1 -type f) ; do
    if [[ \${p} =~ sha256\$ ]] ; then continue ; fi
    n=\"\$(basename \${p})\"
    install -m 0755 \"\${p}\" \"${ridir}/bin/\${n}\"
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
