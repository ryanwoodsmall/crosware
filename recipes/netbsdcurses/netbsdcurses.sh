rname="netbsdcurses"
rver="0.2.2"
rdir="netbsd-curses-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/sabotage-linux/netbsd-curses/archive/${rfile}"
rsha256="c381ec8388a8679be05ac19c83850acff02b60c7e1fd36c1d3dd27cb72b9832c"
rreqs="make"
# we want this to come after ncurses
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

#eval "
#function cwgenprofd_${rname}() {
#  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
#  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> "${rprof}"
#  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> "${rprof}"
#  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> "${rprof}"
#}
#"

eval "
function cwconfigure_${rname}() {
  cwscriptecho "${rname} configure noop"
}
"

# XXX - full term list:
#       awk -F'|' '/\|/&&!/^(#|$|\t)/{print $1}' terminfo/terminfo | sort -u
eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG '/(TERMINFODIR)/ s#TERMINFODIR=#TERMINFO=#g;s#(TERMINFODIR)#(PWD)/terminfo/terminfo#g' GNUmakefile
  sed -i.ORIG '/^screen$/a\\
tmux\\
tmux-256color' libterminfo/genterms
  cd nbperf
  make nbperf CPPFLAGS='-I..' LDFLAGS='-static'
  cd ..
  make -j${cwmakejobs} all-static PREFIX="${ridir}" CPPFLAGS='-I./ -I./libterminfo' LDFLAGS='-static'
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  # LN=echo will disable libncurses symlinks
  make install-static PREFIX="${ridir}" CPPFLAGS='-I./ -I./libterminfo' LDFLAGS='-static' LN='echo'
  rm -f ${ridir}/lib/pkgconfig/ncurses* ${ridir}/lib/pkgconfig/*w.pc
  popd >/dev/null 2>&1
}
"
