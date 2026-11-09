#
# XXX - this doesn't really belong here but is tightly coupled with u-root
#
rname="p9ufs"
rver="0.5.1"
rdir="p9-${rver}"
#rfile="${rver}.zip"
#rurl="https://github.com/hugelgupf/p9/archive/${rfile}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/hugelgupf/p9/archive/refs/tags/${rfile}"
rsha256="7498f2e67a9ba125e6415bbbb25e9fbd9ebe4e45ed051ab6bd1a3cdc0f0bac5a"
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
    env CGO_ENABLED=0 go build -ldflags '-s -w -extldflags \"-s -static\"' -o \$(cwbdir_${rname})/bin/p9ufs \$(cwbdir_${rname})/cmd/p9ufs/.
    chmod -R u+rw . || true
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \$(cwidir_${rname})/bin
  rm -rf \$(cwidir_${rname})/bin/p9ufs
  install -m 755 \$(cwbdir_${rname})/bin/p9ufs \$(cwidir_${rname})/bin/p9ufs
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
