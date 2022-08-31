rname="pinentry"
rver="1.2.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://gnupg.org/ftp/gcrypt/${rname}/${rfile}"
rsha256="457a185e5a85238fb945a955dc6352ab962dc8b48720b62fc9fa48c7540a4067"
rreqs="make slibtool libgpgerror libassuan ncurses pkgconfig configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --enable-pinentry-{curses,tty} \
    --disable-pinentry-{emacs,gtk2,gnome3,qt,qt5,tqt,fltk} \
    --disable-inside-emacs \
    --disable-libsecret \
    --enable-fallback-curses \
    --with-libgpg-error-prefix=\"${cwsw}/libgpgerror/current\" \
    --with-libassuan-prefix=\"${cwsw}/libassuan/current\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
