rname="netbsdcurses"
rver="0.3.1"
rdir="netbsd-curses-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/sabotage-linux/netbsd-curses/archive/${rfile}"
rsha256="bebaf1656440409b0b0e40b5a336c97dcd142e2368b47840a353040fe34d987f"
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
  true
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
