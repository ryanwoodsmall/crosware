rname="screen"
rver="5.0.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="f04a39d00a0e5c7c86a55338808903082ad5df4d73df1a2fd3425976aed94971"
rreqs="make netbsdcurses sed"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} \
    --disable-pam \
    --disable-socket-dir \
    --disable-use-locale \
    --enable-colors256 \
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
