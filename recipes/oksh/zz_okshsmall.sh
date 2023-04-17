rname="okshsmall"
rver="$(cwver_oksh)"
rdir="$(cwdir_oksh)"
rfile="$(cwfile_oksh)"
rdlfile="$(cwdlfile_oksh)"
rurl="$(cwurl_oksh)"
rsha256="$(cwsha256_oksh)"
rreqs="bootstrapmake"
rprof="${cwetcprofd}/zz_${rname}.sh"


. "${cwrecipe}/common.sh"

for f in clean fetch extract patch make ; do
  eval "
    function cw${f}_${rname}() {
      cw${f}_${rname%%small}
    }
    "
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env \
    CPPFLAGS= \
    CFLAGS=\"\${CFLAGS} -Os -g0 -Wl,-s -DEMACS\" \
    LDFLAGS=\"-static -s\" \
      ./configure \
        --prefix=\"\$(cwidir_${rname})\" \
        --bindir=\"\$(cwidir_${rname})/bin\" \
        --mandir=\"\$(cwidir_${rname})/share/man\" \
        --disable-curses \
        --enable-small \
        --enable-ksh \
        --enable-sh \
        --enable-static
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make -j${cwmakejobs} CPPFLAGS= CFLAGS=\"\${CFLAGS} -Os -g0 -Wl,-s -DEMACS\" LDFLAGS=\"-static -s\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  find \$(cwidir_${rname})/bin/ ! -type d | grep '/bin/.*sh' | xargs rm -f &>/dev/null || true
  make install
  mv \"\$(cwidir_${rname})/bin/ksh\" \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/oksh\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/ksh\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/sh\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/oksh/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
