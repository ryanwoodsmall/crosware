rname="gop9p"
rver="37d97cf40d03aece9a223d23bf1c8216c824bd90"
rdir="go-p9p-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/docker-archive/go-p9p/archive/${rfile}"
rsha256="2691453b214e54755ed2790b4e68a9bb4e05ca8217958ab482f1f7a812a842d4"
rreqs="go"

. "${cwrecipe}/common.sh"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  chmod -R u+rw \"\$(cwdir_${rname})\" &>/dev/null || true
  rm -rf \"${rbdir}\"
  popd &>/dev/null
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    export PATH=\"${cwsw}/go/current/bin:\${PATH}\"
    : go mod init github.com/docker-archive/go-p9p
    go mod init github.com/docker/go-p9p
    go mod tidy
  )
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
    : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
    for p in 9p{r,s} ; do
      env \
        CGO_ENABLED=0 \
        GOCACHE=\"\${GOCACHE}\" \
        GOMODCACHE=\"\${GOMODCACHE}\" \
        PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
          go build -ldflags '-s -w' -o \${p} \$(cwbdir_${rname})/cmd/\${p}/
    done
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 755 9pr \"\$(cwidir_${rname})/bin/9pr\"
  install -m 755 9ps \"\$(cwidir_${rname})/bin/9ps\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
