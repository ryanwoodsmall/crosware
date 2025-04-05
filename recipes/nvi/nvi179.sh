rname="nvi179"
rver="1.79"
rdir="${rname%%179}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="https://sites.google.com/a/bostic.com/keithbostic/files/${rfile}?attredirects=0"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname%%179}/${rfile}"
rsha256="755b87aa1e25c24c4c1668de5573d7d9a327b529423ce3ad9ee753bfb2296e33"
rreqs="make netbsdcurses configgit"
rbdir="${cwbuild}/${rdir}/build"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  sed -i.ORIG 's/VI.pm)$/VI.pm || true/g' Makefile.in
  sed -i.ORIG 's,/usr/tmp,/usr/tmp ${cwtop}/tmp,g' configure
  env \
    CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include\" \
    LDFLAGS=\"-L${cwsw}/netbsdcurses/current/lib -static\" \
    LIBS='-lcurses -lterminfo' \
      ./configure \
        ${cwconfigureprefix} \
        --disable-curses \
        --program-prefix=n \
        --program-suffix=${rver//./}
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  eval mkdir -p \"${ridir}/{bin,man,share}\"
  make install
  for n in n{ex,view}${rver//./} ; do
    rm -f \"${ridir}/bin/\${n}\"
    ln -s \"${rtdir}/current/bin/${rname}\" \"${ridir}/bin/\${n}\"
  done
  for n in n{ex,vi{,ew}} ; do
    rm -f \"${ridir}/bin/\${n}\"
    ln -s \"${rtdir}/current/bin/\${n}${rver//./}\" \"${ridir}/bin/\${n}\"
  done
  popd &>/dev/null
}
"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  rm -rf \"${rdir}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
