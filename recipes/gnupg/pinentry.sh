rname="pinentry"
rver="1.1.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://gnupg.org/ftp/gcrypt/${rname}/${rfile}"
rsha256="cd12a064013ed18e2ee8475e669b9f58db1b225a0144debdb85a68cecddba57f"
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
