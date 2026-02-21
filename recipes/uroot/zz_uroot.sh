#
# XXX - this should be a git hash probably?
# XXX - unbundle gobusybox?
# XXX - docker? containerd?  ghostunnel, minio/mc, rclone, wireguard, nebula, 9p client, ssh client/server, caddy, ...
# XXX - more... age, awk replacement, etcd, dasel, gron, jj, jq, miller, minio + mc, sed replacement, toml, webhook, yj, yq
#
rname="uroot"
rurootver="0.15.0"
rgobusyboxver="2e884e4509c722a97c0ec87b1835966eb1a4ad1a"
rmkuimagever="9a40452f5d3ba67f236a83de54fa2c40f797b68b"
relvishver="26a8bd5c4ee1eb5c0a2d53578d0368de2b8b3274"
rver="${rurootver}_${rgobusyboxver}_${rmkuimagever}_${relvishver}_$(cwver_cpu)_$(cwver_p9ufs)"
rdir="u-root-${rurootver}"
rfile="v${rurootver}.tar.gz"
rurl="https://github.com/u-root/u-root/archive/refs/tags/${rfile}"
rsha256="c89f434981803cf53700361effae1efece266fa40a716d504888f8a3e59025b2"
rgover="124"
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
    \"https://github.com/u-root/gobusybox/archive/${rgobusyboxver}.zip\" \
    \"${cwdl}/${rname}/gobusybox/${rgobusyboxver}.zip\" \
    \"e4f554f273a5f5b68f44ad97509c1c386934f07f5bcbc54ffbc41657e366c47c\"
  cwfetchcheck \
    \"https://github.com/u-root/mkuimage/archive/${rmkuimagever}.zip\" \
    \"${cwdl}/${rname}/mkuimage/${rmkuimagever}.zip\" \
    \"705408330184c7a07271f7b671607068774e22f19ca3fd28487c1d48dfd03838\"
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
  cwextract \"${cwdl}/${rname}/gobusybox/${rgobusyboxver}.zip\" \"\$(cwbdir_${rname})\"
  cwextract \"${cwdl}/${rname}/mkuimage/${rmkuimagever}.zip\" \"\$(cwbdir_${rname})\"
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
    go build -o \$(cwbdir_${rname})/bin/u-root \$(cwbdir_${rname})/
    (
      cd \$(cwbdir_${rname})/gobusybox-${rgobusyboxver}/src/
      for c in \${PWD}/cmd/*/ ; do
        go build -o \$(cwbdir_${rname})/bin/\$(basename -- \${c}) \${c} || true
      done
      cd -
    )
    (
      cd \$(cwbdir_${rname})/mkuimage-${rmkuimagever}/
      go build -o \$(cwbdir_${rname})/bin/mkuimage \${PWD}/cmd/mkuimage/ || cwfailexit \"could not build mkuimage\"
      cd -
    )
    (
      cd \$(cwbdir_${rname})/elvish-${relvishver}/
      for c in \${PWD}/cmd/{elvish,elvmdfmt}/ ; do
        go build -o \$(cwbdir_${rname})/bin/\$(basename -- \${c}) \${c} || true
      done
      cd -
    )
    rm -f go.work || true
    go work init . || true
    go work use . || true
    go work use ./gobusybox-${rgobusyboxver}/src/
    go work use ./mkuimage-${rmkuimagever}/
    go work use ./elvish-${relvishver}/
    go work use ./cpu-\$(cwver_cpu)/
    go work use ./p9-\$(cwver_p9ufs)/
    rm -rf bb \$(cwbdir_${rname})/bin/bb
    \$(cwbdir_${rname})/bin/makebb -o \$(cwbdir_${rname})/bin/bb \
      \${PWD}/cmds/*/*/ \
      \${PWD}/mkuimage-${rmkuimagever}/cmd/mkuimage/ \
      \${PWD}/gobusybox-${rgobusyboxver}/src/cmd/{goanywhere,makebb{,main}}/ \
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
