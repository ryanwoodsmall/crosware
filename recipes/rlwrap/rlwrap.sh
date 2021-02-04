#
# XXX - void sources has it too... https://sources.voidlinux.org/rlwrap-0.44/rlwrap-0.44.tar.gz
#

rname="rlwrap"
rver="0.44"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/hanslub42/${rname}/releases/download/${rver}/${rfile}"
rsha256="cd7ff50cde66e443cbea0049b4abf1cca64a74948371fa4f1b5d9a5bbce1e13c"
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
