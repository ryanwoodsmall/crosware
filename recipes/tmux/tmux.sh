rname="tmux"
rver="3.1c"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/${rname}/${rname}/releases/download/${rver}/${rfile}"
rsha256="918f7220447bef33a1902d4faff05317afd9db4ae1c9971bef5c787ac6c88386"
rreqs="make libevent netbsdcurses pkgconfig byacc"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    CPPFLAGS=\"-I${cwsw}/libevent/current/include -I${cwsw}/netbsdcurses/current/include\" \
    LDFLAGS=\"-L${cwsw}/libevent/current/lib -L${cwsw}/netbsdcurses/current/lib -static\" \
    LIBS=\"-lcurses -lterminfo\" \
    YACC=byacc \
    PKG_CONFIG_LIBDIR= \
    PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
