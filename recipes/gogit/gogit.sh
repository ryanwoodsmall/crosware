#
# XXX - only git-{receive,upload}-pack equivalents for now
# XXX - are these good enough to work with got?
# XXX - lots of useful stuff in the _examples/ directory!!!
#
rname="gogit"
rver="5.14.0"
rdir="go-git-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/go-git/go-git/archive/refs/tags/${rfile}"
rsha256="1877e8621a012d17a76537540cf9dc9d05498cb496c47a5dc10ad053c1ccd105"
rreqs="go"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  chmod -R u+rw \"\$(cwdir_${rname})\" &>/dev/null || true
  rm -rf \"${rbdir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
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
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 755 go-git \"\$(cwidir_${rname})/bin/go-git\"
  ln -sf go-git \"\$(cwidir_${rname})/bin/${rname}\"
  echo '#!/usr/bin/env bash' | tee \$(cwidir_${rname})/bin/git-{receive,upload}-pack
  chmod 755 \$(cwidir_${rname})/bin/git-{receive,upload}-pack
  echo '${rtdir}/current/bin/go-git receive-pack \"\${@}\"' | tee -a \$(cwidir_${rname})/bin/git-receive-pack
  echo '${rtdir}/current/bin/go-git upload-pack \"\${@}\"' | tee -a \$(cwidir_${rname})/bin/git-upload-pack
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
