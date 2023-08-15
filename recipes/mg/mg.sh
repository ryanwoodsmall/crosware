#
# XXX - ncurses variant
#

rname="mg"
rver="3.7"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/troglobit/${rname}/releases/download/v${rver}/${rfile}"
rsha256="05101360d2194392da0950e8b6f18d067d8af0fd2f572461ba4d4e7b4ccbb4c1"
rreqs="make netbsdcurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
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
