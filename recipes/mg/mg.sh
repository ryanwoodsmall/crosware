#
# XXX - ncurses variant
#

rname="mg"
rver="3.5"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/troglobit/${rname}/releases/download/v${rver}/${rfile}"
rsha256="a906eab9370c0f24a5fa25923561ad933b74ad339d0b2851d2067badf0d7e4ce"
rreqs="make netbsdcurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include\" \
    LDFLAGS=\"-L${cwsw}/netbsdcurses/current/lib -static\" \
    LIBS=\"-lcurses -lterminfo -static\" \
    PKG_CONFIG_LIBDIR= PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
