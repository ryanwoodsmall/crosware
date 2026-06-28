rname="tea"
rver="0.14.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://gitea.com.fake.url/gitea/tea/${rfile}"
rsha256=""
rreqs="go"

if [ ! command -v git &>/dev/null ] ; then
  rreqs+=" git"
fi

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  chmod -R u+rw \"${rname}\" \"\$(cwdir_${rname})\" &>/dev/null || true
  rm -rf \"${rbdir}\"
  popd &>/dev/null
}
"

eval "
function cwfetch_${rname}() {
  if [ ! -e \$(cwdlfile_${rname}) ] ; then
    pushd ${cwbuild} &>/dev/null
    cwscriptecho \"fetching ${rname} via git\"
    rm -rf \$(cwdir_${rname})
    git clone --single-branch --branch main --depth 1 https://gitea.com/gitea/tea.git \$(cwdir_${rname})
    cwscriptecho \"fetching and checking out tag v\$(cwver_${rname})\"
    git -C \$(cwdir_${rname}) fetch --tags
    git -C \$(cwdir_${rname}) checkout -b {local_,}v\$(cwver_${rname})
    cwscriptecho \"archiving to \$(cwdlfile_${rname})\"
    tar -cf - \$(cwdir_${rname}) | gzip -9 > \$(cwdlfile_${rname})
    popd
  else
    cwscriptecho \"using archived \$(cwdlfile_${rname})\"
  fi
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
    : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
    env \
      CGO_ENABLED=0 \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
        go mod vendor
    env \
      CGO_ENABLED=0 \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
        go build -ldflags '-s -w -extldflags \"-s -static\"' -o \"${rname}\"
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 755 \"${rname}\" \"\$(cwidir_${rname})/bin/${rname}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
