rname="smbiosdmidecode"
rver="1465ce6f76170642ad51ac0aa474107797d812e9"
rdir="smbios-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/u-root/smbios/archive/${rfile}"
rsha256="490f9c389549c79fdbc227d437818e9ad511d6b806322932c9fd812a92b847db"
rreqs="go cacertificates"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
    : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
    export GOCACHE
    export GOMODCACHE
    export PATH=\"${cwsw}/go/current/bin:\${PATH}\"
    cwmkdir \$(cwbdir_${rname})/bin
    env CGO_ENABLED=0 go build -ldflags '-s -w -extldflags \"-s -static\"' -o bin/dmidecode \$(cwbdir_${rname})/cmd/dmidecode/.
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \$(cwidir_${rname})/bin
  rm -rf \$(cwidir_${rname})/dmidecode
  install -m 755 bin/dmidecode \$(cwidir_${rname})/bin/dmidecode
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
