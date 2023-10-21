rname="sbase"
rver="090490b81d01f4e1da005560669fbb1239c88989"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rprof="${cwetcprofd}/zz_${rname}.sh"
rsha256="f7778d8e83ebe44ebfcd293f0c25158a8ceb0182a6ae5682c0773c241cf816e0"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/suckless/suckless.sh.common"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ( unset CPPFLAGS ; make sbase-box ) || cwfailexit \"${rname}: build failed\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwscriptecho \"${rname}: manually installing\"
  rm -rf \$(cwidir_${rname})/{bin,share} || true
  cwmkdir \$(cwidir_${rname})/bin
  install -m 755 sbase-box \$(cwidir_${rname})/bin/sbase-box
  ( cd \$(cwidir_${rname})/bin ; for a in \$(./sbase-box) ; do ln -sf sbase-box \${a} ; done )
  cwmkdir \$(cwidir_${rname})/share/man/man1
  install -m 644 *.1 \$(cwidir_${rname})/share/man/man1/
  popd >/dev/null 2>&1
}
"
