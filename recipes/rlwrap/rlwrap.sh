rname="rlwrap"
rver="0.43"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/hanslub42/${rname}/releases/download/v${rver}/${rfile}"
rsha256="8e86d0b7882d9b8a73d229897a90edc207b1ae7fa0899dca8ee01c31a93feb2f"
rreqs="make netbsdcurses configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include -I${cwsw}/netbsdcurses/current/include/readline\" \
    LDFLAGS=\"-L${cwsw}/netbsdcurses/current/lib -static\" \
    LIBS=\"-lreadline -lcurses -lterminfo\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
