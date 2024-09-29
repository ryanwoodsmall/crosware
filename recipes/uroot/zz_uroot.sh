#
# XXX - this should be a git hash probably?
# XXX - unbundle gobusybox?
# XXX - docker? containerd? tini, ghostunnel, minio/mc, rclone, wireguard, nebula, 9p client, ssh client/server, caddy, ...
#
rname="uroot"
rurootver="0.14.0"
rgobusyboxver="d8fbaca23e26beab648c86c8a67335ad65d0d15c"
rmkuimagever="899a47eaaa318bd2327dc94d964ccda40a784037"
rver="${rurootver}_${rgobusyboxver}_${rmkuimagever}_$(cwver_cpu)_$(cwver_p9ufs)"
rdir="u-root-${rurootver}"
rfile="v${rurootver}.tar.gz"
rurl="https://github.com/u-root/u-root/archive/refs/tags/${rfile}"
rsha256="fb45d0ab2dac3ea56e9496d659b167031c90496c330090ba74e77c3c64265302"
rreqs="go cacertificates"
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
    \"58e7a7b271b5cb4c551ea76a64593d74f4286acf7c3d6d4deb32065a91ffe867\" 
  cwfetchcheck \
    \"https://github.com/u-root/mkuimage/archive/${rmkuimagever}.zip\" \
    \"${cwdl}/${rname}/mkuimage/${rmkuimagever}.zip\" \
    \"fe09718a82f9d510b375dc7d5e15aa46f5d7c419c1054d62a5d12701ac7d17e5\"
}
"

eval "
function cwextract_${rname}() {
  cwextract \"\$(cwdlfile_${rname})\" \"${cwbuild}\"
  cwextract \"\$(cwdlfile_cpu)\" \"\$(cwbdir_${rname})\"
  cwextract \"\$(cwdlfile_p9ufs)\" \"\$(cwbdir_${rname})\"
  cwextract \"${cwdl}/${rname}/gobusybox/${rgobusyboxver}.zip\" \"\$(cwbdir_${rname})\"
  cwextract \"${cwdl}/${rname}/mkuimage/${rmkuimagever}.zip\" \"\$(cwbdir_${rname})\"
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
    export PATH=\"${cwsw}/go/current/bin:\${PATH}\"
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
    rm -f go.work || true
    go work init . || true
    go work use . || true
    go work use ./gobusybox-${rgobusyboxver}/src/
    go work use ./mkuimage-${rmkuimagever}/
    go work use ./cpu-\$(cwver_cpu)/
    go work use ./p9-\$(cwver_p9ufs)/
    rm -rf bb \$(cwbdir_${rname})/bin/bb
    \$(cwbdir_${rname})/bin/makebb -o \$(cwbdir_${rname})/bin/bb \
      \${PWD}/cmds/*/*/ \
      \${PWD}/mkuimage-${rmkuimagever}/cmd/mkuimage/ \
      \${PWD}/gobusybox-${rgobusyboxver}/src/cmd/{goanywhere,makebb{,main}}/ \
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
      test -e \${a} || { echo -n \" \${a}\" ; ln -sf bb \${a} ; }
    done
    echo
    rm -rf bb
    ln -sf ${rtdir}/current/bin/bb bb
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
