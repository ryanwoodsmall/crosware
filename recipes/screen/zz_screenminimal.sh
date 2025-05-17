#
# XXX - crashes on centos 7 with a sigsev if xterm-color, a 256 color term, etc. $TERM is set
#
rname="screenminimal"
rver="4.9.1"
rdir="${rname%minimal}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname%minimal}/${rfile}"
rsha256="26cef3e3c42571c0d484ad6faf110c5c15091fbf872b06fa7aa4766c7405ac69"
rreqs="bootstrapmake bashtermcap"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

#for f in fetch clean extract ; do
#  eval "function cw${f}_${rname}() { cw${f}_${rname%%minimal} ; }"
#done
#unset f

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cat configure > configure.ORIG
  sed -i 's/as_fn_error.*tgetent.*/true/g' configure
  sed -i 's/-ltinfo//g' configure
  popd &>/dev/null
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
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
  echo '#undef TERMINFO' >> config.h
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install
  rm -f \"\$(cwidir_${rname})/bin/${rname}\"
  rm -f \"\$(cwidir_${rname})/bin/${rname}-${rver}\"
  mv \"\$(cwidir_${rname})/bin/screen\" \"\$(cwidir_${rname})/bin/${rname}\"
  mv \"\$(cwidir_${rname})/bin/screen-${rver}\" \"\$(cwidir_${rname})/bin/${rname}-${rver}\"
  ln -sf ${rname}-${rver} \"\$(cwidir_${rname})/bin/screen-${rver}\"
  ln -sf ${rname} \"\$(cwidir_${rname})/bin/screen${rver%%.*}\"
  echo '#!/usr/bin/env bash' > \"\$(cwidir_${rname})/bin/screen\"
  echo 'env TERM=screen ${rtdir}/current/bin/${rname} \"\${@}\"' >> \"\$(cwidir_${rname})/bin/screen\"
  chmod 755 \"\$(cwidir_${rname})/bin/screen\"
  echo 'hardstatus alwayslastline \"%Lw\"' >> etc/screenrc
  cwmkdir \"\$(cwidir_${rname})/etc\"
  install -m 0644 etc/screenrc \"\$(cwidir_${rname})/etc/screenrc\"
  install -m 0644 etc/etcscreenrc \"\$(cwidir_${rname})/etc/etcscreenrc\"
  cwmkdir \"\$(cwidir_${rname})/share/terminfo\"
  install -m 0644 terminfo/screeninfo.src \"\$(cwidir_${rname})/share/terminfo/screeninfo.src\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/${rname%minimal}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
