rname="plan9port9p"
rver="$(cwver_plan9port)"
rdir="$(cwdir_plan9port)"
rfile="$(cwfile_plan9port)"
rdlfile="$(cwdlfile_plan9port)"
rurl="$(cwurl_plan9port)"
rsha256=""
rreqs="9base"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetch_${rname%9p}
}
"

# unzip is incredibly loud, add "-q"?
eval "
function cwextract_${rname}() {
  cwextract \"\$(cwdlfile_${rname})\" \"${cwbuild}\" &>/dev/null
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG '/^LDFLAGS/s/=/=-static/g' src/mkhdr
  sed -i.ORIG '/</s,1024,0,g' src/libthread/pthread.c
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cd src
  for l in 9 9pclient auth authsrv bio ip mux ndb thread ; do
    ( cd lib\${l}/ ; env PLAN9=\"\$(cwbdir_${rname})\" PATH=\"\$(cwbdir_${rname})/bin:\${PATH}\" \"${cwsw}/9base/current/bin/mk\" CC9=\"\${CC}\" )
  done
  cd cmd
  env PLAN9=\"\$(cwbdir_${rname})\" PATH=\"\$(cwbdir_${rname})/bin:\${PATH}\" \"${cwsw}/9base/current/bin/mk\" 9p.install CC9=\"\${CC}\"
  cd 9pfuse
  env PLAN9=\"\$(cwbdir_${rname})\" PATH=\"\$(cwbdir_${rname})/bin:\${PATH}\" \"${cwsw}/9base/current/bin/mk\" 9pfuse.install CC9=\"\${CC}\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  cwmkdir \"\$(cwidir_${rname})/man/man1\"
  cwmkdir \"\$(cwidir_${rname})/man/man4\"
  install -m 0755 bin/9p \"\$(cwidir_${rname})/bin/\"
  install -m 0755 bin/9pfuse \"\$(cwidir_${rname})/bin/\"
  install -m 0644 man/man1/9p.1 \"\$(cwidir_${rname})/man/man1/\"
  install -m 0644 man/man4/9pfuse.4 \"\$(cwidir_${rname})/man/man4/\"
  find \"\$(cwidir_${rname})/bin/\" ! -type d | xargs \$(\${CC} -dumpmachine)-strip --strip-all || true
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
