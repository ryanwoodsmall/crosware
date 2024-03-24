#
# XXX - netbsdcurses?
#
rname="pinentry"
rver="1.3.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://gnupg.org/ftp/gcrypt/${rname}/${rfile}"
rsha256="9b3cd5226e7597f2fded399a3bc659923351536559e9db0826981bca316494de"
rreqs="make slibtool libgpgerror libassuan ncurses pkgconfig configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} \
    --enable-pinentry-{curses,tty} \
    --disable-pinentry-{emacs,gtk2,gnome3,qt,qt5,tqt,fltk} \
    --disable-inside-emacs \
    --disable-libsecret \
    --enable-fallback-curses \
    --with-libgpg-error-prefix=\"${cwsw}/libgpgerror/current\" \
    --with-libassuan-prefix=\"${cwsw}/libassuan/current\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
