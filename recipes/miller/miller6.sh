#
# XXX - don't really need make, but it's recommend in the readme
# XXX - regular `make`/`make install` with proper vars works fine!
# XXX - vim integration files???
#

rname="miller6"
rver="6.12.0"
rdir="${rname%6}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/johnkerl/miller/archive/refs/tags/${rfile}"
rsha256="e97dab1a514ecd88da9374b2a5759cebc607476596f6b1d6d8fbe444b9e0eab2"
rreqs="bootstrapmake go"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})\"
  ./configure --prefix=\"\$(cwidir_${rname})\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  (
    : \${GOCACHE=\"\$(cwbdir_${rname})/gocache\"}
    : \${GOMODCACHE=\"\$(cwbdir_${rname})/gomodcache\"}
    env \
      PATH=\"${cwsw}/go/current/bin:\${PATH}\" \
      GOCACHE=\"\${GOCACHE}\" \
      GOMODCACHE=\"\${GOMODCACHE}\" \
      GOPATH=\"\$(cwbdir_${rname})/gopath\" \
      GOROOT=\"${cwsw}/go/current\" \
        go build -ldflags '-s -w -extldflags \"-s -static\"' -o mlr \"\$(cwbdir_${rname})/cmd/mlr\"
    chmod -R u+rw . || true
  )
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  cwmkdir \"\$(cwidir_${rname})/share/man/man1\"
  install -m 0755 mlr \"\$(cwidir_${rname})/bin/mlr\"
  install -m 0755 man/mlr.1 \"\$(cwidir_${rname})/share/man/man1/mlr.1\"
  ln -sf mlr \"\$(cwidir_${rname})/bin/mlr6\"
  ln -sf mlr \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf mlr \"\$(cwidir_${rname})/bin/${rname%6}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
