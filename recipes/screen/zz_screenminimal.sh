#
# XXX - crashes on centos 7 with a sigsev if xterm-color, a 256 color term, etc. $TERM is set
#
rname="screenminimal"
rver="$(cwver_screen)"
rdir="$(cwdir_screen)"
rfile="$(cwfile_screen)"
rdlfile="$(cwdlfile_screen)"
rurl="$(cwurl_screen)"
rsha256="$(cwsha256_screen)"
rreqs="bootstrapmake bashtermcap"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --disable-pam \
    --disable-socket-dir \
    --disable-use-locale \
    --disable-colors256 \
      CFLAGS=\"\${CFLAGS} -Wl,-s -g0 -Os\" \
      CPPFLAGS=\"-I${cwsw}/bashtermcap/current/include\" \
      LDFLAGS=\"-L${cwsw}/bashtermcap/current/lib -static -s\" \
      LIBS=-ltermcap \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install
  rm -f \"\$(cwidir_${rname})/bin/${rname}\"
  rm -f \"\$(cwidir_${rname})/bin/${rname}-${rver}\"
  mv \"\$(cwidir_${rname})/bin/screen\" \"\$(cwidir_${rname})/bin/${rname}\"
  mv \"\$(cwidir_${rname})/bin/screen-${rver}\" \"\$(cwidir_${rname})/bin/${rname}-${rver}\"
  ln -sf ${rname}-${rver} \"\$(cwidir_${rname})/bin/screen-${rver}\"
  echo '#!/usr/bin/env bash' > \"\$(cwidir_${rname})/bin/screen\"
  echo 'env TERM=screen ${rtdir}/current/bin/${rname} \"\${@}\"' >> \"\$(cwidir_${rname})/bin/screen\"
  chmod 755 \"\$(cwidir_${rname})/bin/screen\"
  echo 'hardstatus alwayslastline \"%Lw\"' >> etc/screenrc
  cwmkdir \"\$(cwidir_${rname})/etc\"
  install -m 0644 etc/screenrc \"\$(cwidir_${rname})/etc/screenrc\"
  install -m 0644 etc/etcscreenrc \"\$(cwidir_${rname})/etc/etcscreenrc\"
  cwmkdir \"\$(cwidir_${rname})/share/terminfo\"
  install -m 0644 terminfo/screeninfo.src \"\$(cwidir_${rname})/share/terminfo/screeninfo.src\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/${rname%minimal}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
