#
# XXX - only git-{receive,upload}-pack equivalents for now
# XXX - are these good enough to work with got?
# XXX - lots of useful stuff in the _examples/ directory!!!
#
rname="gogit"
rver="5.16.5"
rdir="go-git-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/go-git/go-git/archive/refs/tags/${rfile}"
rsha256="a11ff799357d9d0e0f253ce50ffa908ee014ce02eca54718dba17da5e486a45d"
rreqs="go"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  chmod -R u+rw \"\$(cwdir_${rname})\" &>/dev/null || true
  rm -rf \"${rbdir}\"
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
    : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
    cd cli/go-git/
    env \
      CGO_ENABLED=0 \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
        go build -ldflags '-s -w -extldflags \"-s -static\"' -o ../../go-git
    cd -
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 755 go-git \"\$(cwidir_${rname})/bin/go-git\"
  ln -sf go-git \"\$(cwidir_${rname})/bin/${rname}\"
  echo '#!/usr/bin/env bash' | tee \$(cwidir_${rname})/bin/git-{receive,upload}-pack
  chmod 755 \$(cwidir_${rname})/bin/git-{receive,upload}-pack
  echo '${rtdir}/current/bin/go-git receive-pack \"\${@}\"' | tee -a \$(cwidir_${rname})/bin/git-receive-pack
  echo '${rtdir}/current/bin/go-git upload-pack \"\${@}\"' | tee -a \$(cwidir_${rname})/bin/git-upload-pack
  mkdir -p \$(cwidir_${rname})/_examples
  ( cd ./_examples/ ; tar -cf - . ) | ( cd \$(cwidir_${rname})/_examples/ ; tar -xf - )
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
