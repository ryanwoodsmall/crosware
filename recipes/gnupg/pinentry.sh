#
# XXX - netbsdcurses?
#
rname="pinentry"
rver="1.3.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://gnupg.org/ftp/gcrypt/${rname}/${rfile}"
rsha256="bc72ee27c7239007ab1896c3c2fae53b076e2c9bd2483dc2769a16902bce8c04"
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
