rname="pinentry"
rver="1.1.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://gnupg.org/ftp/gcrypt/${rname}/${rfile}"
rsha256="68076686fa724a290ea49cdf0d1c0c1500907d1b759a3bcbfbec0293e8f56570"
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
