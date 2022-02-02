rname="screen"
rver="4.9.0"
rdir="${rname}-${rver}"
#rfile="${rdir}.tar.gz"
#rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="8a8fc8fe9f32b61f4ce5ee82771ceab9eb0893e5b827b2f113bb7bb4a201ccb4"
rreqs="make netbsdcurses sed"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} --enable-colors256 \
    CPPFLAGS=\"-I${cwsw}/libevent/current/include -I${cwsw}/netbsdcurses/current/include\" \
    LDFLAGS=\"-L${cwsw}/libevent/current/lib -L${cwsw}/netbsdcurses/current/lib -static\" \
    LIBS=\"-lcurses -lterminfo\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make install
  echo 'hardstatus alwayslastline \"%Lw\"' >> etc/screenrc
  cwmkdir \"${ridir}/etc\"
  install -m 0644 etc/screenrc \"${ridir}/etc/screenrc\"
  install -m 0644 etc/etcscreenrc \"${ridir}/etc/etcscreenrc\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
