#
# XXX - trying to follow "latest" (#.N.#) - may want to switch to "stable" (#.N-#.#)?
# XXX - name contains +, which is urlencoded to %2B
# XXX - don't like + in dir/file names
# XXX - json of channels - "stable" here: https://update.k3s.io/v1-release/channels
# XXX - package for airgap images? k3s-airgap-images-${ARCH}.tar{,.{gz,zst}}
# XXX - this recipe _always_ fetches the sha256sum file, so needs to be online
# XXX - without airgap, that makes sense, but i'm not a huge fan of this approach (no caching, no offline)
#

rname="k3s"
rver="1.26.0_${rname}1"
rdir="${rname}-${rver}"
rfile=""
rreqs=""
rsha256=""
rburl="https://github.com/k3s-io/k3s/releases/download/v${rver//_/%2B}"
if [[ ${karch} =~ ^aarch64 ]] ; then
  rfile="${rname}-arm64"
elif [[ ${karch} =~ ^arm ]] ; then
  rfile="${rname}-armhf"
elif [[ ${karch} =~ ^x86_64 ]] ; then
  rfile="${rname}"
fi
rurl="${rburl}/${rfile}"

. "${cwrecipe}/common.sh"

if [[ ${karch} =~ ^(i.86|riscv64) ]] ; then
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
  local a=''
  if [[ ${karch} =~ ^x86_64  ]] ; then a='amd64' ; fi
  if [[ ${karch} =~ ^arm     ]] ; then a='arm'   ; fi
  if [[ ${karch} =~ ^aarch64 ]] ; then a='arm64' ; fi
  local shafile=\"sha256sum-\${a}.txt\"
  local shaurl=\"${rburl}/\${shafile}\"
  cwfetch \"\${shaurl}\" \"${cwdl}/${rname}/\${shafile}\"
  local rsha256=\"\$(grep -v images ${cwdl}/${rname}/\${shafile} | egrep ${rfile}\$ | awk '{print \$1}')\"
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\${rsha256}\"
  cwechofunc \"cwsha256_${rname}\" \"\${rsha256}\"
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 0755 \"\$(cwdlfile_${rname})\" \"\$(cwidir_${rname})/bin/${rname}\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"

unset rburl
