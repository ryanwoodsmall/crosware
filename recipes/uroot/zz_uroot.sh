#
# XXX - this should be a git hash probably?
# XXX - unbundle gobusybox?
# XXX - docker? containerd?  ghostunnel, minio/mc, rclone, wireguard, nebula, 9p client, ssh client/server, caddy, ...
# XXX - more... age, awk replacement, etcd, dasel, gron, jj, jq, miller, minio + mc, sed replacement, toml, webhook, yj, yq
# XXX - minimum viable kubernetes / k8s https://eevans.co/blog/minimum-viable-kubernetes/
# XXX - tools from https://github.com/u-root/k4s - containerd, runc, etcdctl, ...
#
rname="uroot"
rurootver="0.16.0"
rgobusyboxver="0.3.0"
rmkuimagever="0.1.0"
relvishver="26a8bd5c4ee1eb5c0a2d53578d0368de2b8b3274"
rver="${rurootver}_${rgobusyboxver}_${rmkuimagever}_${relvishver}_$(cwver_cpu)_$(cwver_p9ufs)"
rdir="u-root-${rurootver}"
rfile="v${rurootver}.tar.gz"
rurl="https://github.com/u-root/u-root/archive/refs/tags/${rfile}"
rsha256="161da1394da9acd96f69957620db630ce086f71bef62785bad4a82884eee9b77"
rgover="126"
rreqs="go${rgover} cacertificates"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\$(cwsha256_${rname})\"
  cwfetch_cpu
  cwfetch_p9ufs
  cwfetchcheck \
    \"https://github.com/u-root/gobusybox/archive/refs/tags/src/v${rgobusyboxver}.tar.gz\" \
    \"${cwdl}/${rname}/gobusybox/v${rgobusyboxver}.tar.gz\" \
    \"9b2a51f1ff1d94e0052eba34bb370b42df5aa4dd18d6d8fa2f9f3be46aa29c59\"
  cwfetchcheck \
    \"https://github.com/u-root/mkuimage/archive/refs/tags/v${rmkuimagever}.tar.gz\" \
    \"${cwdl}/${rname}/mkuimage/v${rmkuimagever}.tar.gz\" \
    \"e503ef8534b5802ae679d09ff7514a9aa1daca9b7f2e30d19707e48959ae8cae\"
  cwfetchcheck \
    \"https://github.com/elves/elvish/archive/${relvishver}.zip\" \
    \"${cwdl}/${rname}/elvish/${relvishver}.zip\" \
    \"f54c2523494ecefe48d07294b0f13f80143ff56eac2375a8a05ec766edbaa5e2\"
}
"

eval "
function cwextract_${rname}() {
  cwextract \"\$(cwdlfile_${rname})\" \"${cwbuild}\"
  cwextract \"\$(cwdlfile_cpu)\" \"\$(cwbdir_${rname})\"
  cwextract \"\$(cwdlfile_p9ufs)\" \"\$(cwbdir_${rname})\"
  cwextract \"${cwdl}/${rname}/gobusybox/v${rgobusyboxver}.tar.gz\" \"\$(cwbdir_${rname})\"
  cwextract \"${cwdl}/${rname}/mkuimage/v${rmkuimagever}.tar.gz\" \"\$(cwbdir_${rname})\"
  cwextract \"${cwdl}/${rname}/elvish/${relvishver}.zip\" \"\$(cwbdir_${rname})\"
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
    : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
    export GOCACHE
    export GOMODCACHE
    export GOPATH=\"\$(cwbdir_${rname})/gopath\"
    export PATH=\"${cwsw}/go${rgover}/current/bin:\${PATH}\"
    export CGO_ENABLED=0
    cwmkdir \$(cwbdir_${rname})/bin
    cwscriptecho 'building u-root'
    go build -o \$(cwbdir_${rname})/bin/u-root \$(cwbdir_${rname})/
    (
      cwscriptecho 'building gobusybox'
      cd \$(cwbdir_${rname})/gobusybox-src-v${rgobusyboxver}/src/
      for c in \${PWD}/cmd/*/ ; do
        go build -o \$(cwbdir_${rname})/bin/\$(basename -- \${c}) \${c} || true
      done
      cd -
    )
    (
      cwscriptecho 'building mkuimage'
      cd \$(cwbdir_${rname})/mkuimage-${rmkuimagever}/
      go build -o \$(cwbdir_${rname})/bin/mkuimage \${PWD}/cmd/mkuimage/ || cwfailexit \"could not build mkuimage\"
      cd -
    )
    (
      cwscriptecho 'building elvish'
      cd \$(cwbdir_${rname})/elvish-${relvishver}/
      for c in \${PWD}/cmd/{elvish,elvmdfmt}/ ; do
        go build -o \$(cwbdir_${rname})/bin/\$(basename -- \${c}) \${c} || true
      done
      cd -
    )
    cwscriptecho 'setting up go work dirs'
    rm -f go.work || true
    go work init . || true
    go work use . || true
    go work use ./gobusybox-src-v${rgobusyboxver}/src/
    go work use ./mkuimage-${rmkuimagever}/
    go work use ./elvish-${relvishver}/
    go work use ./cpu-\$(cwver_cpu)/
    go work use ./p9-\$(cwver_p9ufs)/
    rm -rf bb \$(cwbdir_${rname})/bin/bb
    cwscriptecho 'building bb with extra commands'
    \$(cwbdir_${rname})/bin/makebb -o \$(cwbdir_${rname})/bin/bb \
      \${PWD}/cmds/*/*/ \
      \${PWD}/mkuimage-${rmkuimagever}/cmd/mkuimage/ \
      \${PWD}/gobusybox-src-v${rgobusyboxver}/src/cmd/{goanywhere,makebb{,main}}/ \
      \${PWD}/elvish-${relvishver}/cmd/{elvish,elvmdfmt}/ \
      \${PWD}/cpu-\$(cwver_cpu)/cmds/{cpu{,d},decpu}/ \
      \${PWD}/p9-\$(cwver_p9ufs)/cmd/p9ufs/
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \$(cwidir_${rname})/bin
  rm -rf \$(cwidir_${rname})/bin/* || true
  install -m 755 bin/* \$(cwidir_${rname})/bin/
  rm -rf \$(cwidir_${rname})/gobusybox || true
  cwmkdir \$(cwidir_${rname})/gobusybox
  (
    cd \$(cwidir_${rname})/gobusybox/
    echo -n linking...
    for a in \$(\$(cwidir_${rname})/bin/bb |& tr '\\t' ' ' | tr -s ' ' | awk '/^ - /{print \$NF}' | sort ) ; do
      test -e \${a} || { echo -n \" \${a}\" ; ln -sf ${rtdir}/current/bin/bb \${a} ; }
    done
    echo
    cd -
  )
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

unset rurootver
unset rgobusyboxver
unset rmkuimagever
unset relvishver
unset rgover
