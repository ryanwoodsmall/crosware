#
# XXX - update checker https://storage.googleapis.com/kubernetes-release/release/stable.txt
# XXX - download/check w:
#   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
#   curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
# XXX - kubelet is glibc, probably need to compile? ugh?
#

rname="kubernetes"
rver="1.21.2"
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

rburl="https://dl.k8s.io/release/v${rver}/bin/linux"
eval "
function cwfetch_${rname}() {
  local a p f u d
  declare -A kubesha256
  kubesha256['kubeadm-amd64']='6a83e52e51f41d67658a13ce8ac9deb77a6d82a71ced2d106756f6d38756ec00'
  kubesha256['kubectl-amd64']='55b982527d76934c2f119e70bf0d69831d3af4985f72bb87cd4924b1c7d528da'
  kubesha256['kubelet-amd64']='aaf144b19c0676e1fe34a93dc753fb38f4de057a0e2d7521b0bef4e82f8ccc28'
  kubesha256['kube-proxy-amd64']='fca07965efa9435e20d24a2c4501b5c80c1f775793352aff2649e6b342c76537'
  kubesha256['kubeadm-arm']='75251be6394ca3fedf578a1ba3bc7d7f01e60402b83658ccf2439d1c48379846'
  kubesha256['kubectl-arm']='898c2cd54b651873a8fb18bcb0792eb4772a78f845d758fa9b0eee278aede869'
  kubesha256['kubelet-arm']='577e09db9e8c11a57eeaa060fddc907df2b026b5270768201adcaafd9c6aa7b7'
  kubesha256['kube-proxy-arm']='ed3395709ec27887223e06926c7f91a88635dd796829b622ded16e0219171dec'
  kubesha256['kubeadm-arm64']='245125dc436f649466123a2d2c922d17f300cbc20d2b75edad5e42d734ead4a3'
  kubesha256['kubectl-arm64']='5753051ed464d0f1af05a3ca351577ba5680a332d5b2fa7738f287c8a40d81cf'
  kubesha256['kubelet-arm64']='525cf5506595e70bffc4c1845b3c535c7121fa2ee3daac6ca3edc69d8d63b89f'
  kubesha256['kube-proxy-arm64']='a0aa46202e3b42f9241e4b698eaa0524a63e305acd289b00fbe643291ef87f39'
  kubesha256['kubectl-386']='c678983bce217d272689dd1dd87c0300464b21061c676597232c1d32eb8c76be'
  echo ${karch} | grep -q ^x86_64 && a='amd64' || true
  echo ${karch} | grep -q ^arm && a='arm' || true
  echo ${karch} | grep -q ^aarch64 && a='arm64' || true
  echo ${karch} | grep -q ^i && a='386' || true
  for p in \${!kubesha256[@]} ; do
    if [[ \${p} =~ -\${a}\$ ]] ; then
      f=\"\${p%-\${a}}\"
      u=\"${rburl}/\${a}/\${f}\"
      d=\"${cwdl}/${rname}/\${p}_${rver}\"
      cwfetchcheck \"\${u}\" \"\${d}\" \"\${kubesha256[\${p}]}\"
    fi
  done
}
"
unset rburl

eval "
function cwmakeinstall_${rname}() {
  echo ${karch} | grep -q ^x86_64 && a='amd64' || true
  echo ${karch} | grep -q ^arm && a='arm' || true
  echo ${karch} | grep -q ^aarch64 && a='arm64' || true
  echo ${karch} | grep -q ^i && a='386' || true
  cwmkdir \"${ridir}/bin\"
  for p in kubeadm kubectl kubelet kube-proxy ; do
    f=\"${cwdl}/${rname}/\${p}-\${a}_${rver}\"
    test -e \"\${f}\" \
    && install -m 0755 \"\${f}\" \"${ridir}/bin/\${p}\" \
    || true
  done
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
