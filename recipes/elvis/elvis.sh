rname="elvis"
rver="2.2_1-pre2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/mbert/${rname}/releases/download/v${rver}/${rfile}"
rsha256="6a84f7a76a362e3627c2f1325e09c5c9b5c7bfeac5a60a1360b82cdd37be1efe"
rreqs="make netbsdcurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG 's/TLIBS=\"-lcurses\"/TLIBS=\"-lcurses -lterminfo -static\"/g' configure
  sed -i.ORIG '/^\\t.*CC/s/EXE)\$/EXE) -static/g' Makefile.in
  sed -i '/^ALL=/s/\$/ ctags/' Makefile.in
  env CPPFLAGS= LDFLAGS= \
    ./configure ${cwconfigureprefix} \
      --verbose \
      --ioctl=termios \
      --without-{x{,ft},gnome} \
        linux
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make \
    CC=\"\${CC} \${CFLAGS} -I${cwsw}/netbsdcurses/current/include -L${cwsw}/netbsdcurses/current/lib\" \
    CPPFLAGS= \
    LDFLAGS=-static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}\"
  make install
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
