rname="screen"
rver="5.0.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/screen/${rfile}"
rsha256="2dae36f4db379ffcd14b691596ba6ec18ac3a9e22bc47ac239789ab58409869d"
rreqs="make netbsdcurses sed"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} \
    --disable-pam \
    --disable-socket-dir \
    --enable-telnet \
    --with-system_screenrc=\"${rtdir}/current/etc/screenrc\" \
      CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include\" \
      LDFLAGS=\"-L${cwsw}/netbsdcurses/current/lib -static\" \
      LIBS=\"-lcurses -lterminfo\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install
  ln -sf ${rname} \"\$(cwidir_${rname})/bin/screen${rver%%.*}\"
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
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
