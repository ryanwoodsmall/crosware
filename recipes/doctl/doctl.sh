rname="doctl"
rver="1.96.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/digitalocean/doctl/archive/refs/tags/${rfile}"
rsha256="5963bfb113632df33d0ef6c2d076cedd180f73ce82f3162e7d1bc93b190a9951"
rreqs="go"

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
  : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
  : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
  local b=\"-X github.com/digitalocean/doctl\"
  local maj=${rver%%.*}
  local pat=${rver##*.}
  local min=${rver}
  min=\${min#\${maj}.}
  min=\${min%.\${pat}}
  local bld=000000000
  local lab=release
  local ext=\"\${b}.Major=\${maj} \${b}.Minor=\${min} \${b}.Patch=\${pat} \${b}.Build=\${bld} \${b}.Label=\${lab}\"
  env \
    CGO_ENABLED=0 \
    GOCACHE=\"\${GOCACHE}\" \
    GOMODCACHE=\"\${GOMODCACHE}\" \
    PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
      go build -ldflags \"-s -w \${ext}\" -o ${rname} \"\$(cwbdir_${rname})/cmd/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 755 ${rname} \"\$(cwidir_${rname})/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
