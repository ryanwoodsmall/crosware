rname="doctl"
rver="1.115.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/digitalocean/doctl/archive/refs/tags/${rfile}"
rsha256="08c33702fa29d321b7ab005d16ddbc40d4acc6b0c1141080a127b820ae871156"

rreqs="go"

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
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 755 ${rname} \"\$(cwidir_${rname})/bin/${rname}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
