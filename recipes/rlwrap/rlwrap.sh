#
# XXX - void sources has it too... https://sources.voidlinux.org/rlwrap-0.44/rlwrap-0.44.tar.gz
# XXX - fossies: https://fossies.org/linux/privat/rlwrap-0.45.tar.gz/
#

rname="rlwrap"
rver="0.45.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="https://github.com/hanslub42/${rname}/releases/download/${rver}/${rfile}"
rurl="https://github.com/ryanwoodsmall/${rname}/releases/download/v${rver}/${rfile}"
rsha256="57d81c3a402f5bcde711bdcbb16c3f5f5a8c5a6ad6536165cd3d101b44f7b82a"
rreqs="make netbsdcurses configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include -I${cwsw}/netbsdcurses/current/include/readline\" \
    LDFLAGS=\"-L${cwsw}/netbsdcurses/current/lib -static\" \
    LIBS=\"-lreadline -lcurses -lterminfo\"
  which pod2man || sed -i.ORIG 's/pod2man/echo pod2man/g' filters/Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
