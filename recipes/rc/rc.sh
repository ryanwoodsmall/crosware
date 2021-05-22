rname="rc"
rver="21016570f4b42a0814134c43e8e27c388856ee5e"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="070cd078090da69a90aadbb613a6148569c9692106ddf9f2c5df9ba08d41fb24"
rreqs="make netbsdcurses byacc"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cat Makefile > Makefile.ORIG
  sed -i '/^DESCRIPTION/s,^DESCRIPTION.*,DESCRIPTION=${rname}-${rver},g' Makefile
  sed -i '/^PREFIX/s,^PREFIX.*,PREFIX=${ridir},g' Makefile
  sed -i 's,-lreadline,-lreadline -lcurses -lterminfo,g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include\" LDFLAGS=\"-L${cwsw}/netbsdcurses/current/lib -static\" CFLAGS=\"\${CFLAGS}\" CC=\"\${CC} \${CFLAGS} -static\"
  make history mksignal mkstatval tripping LDFLAGS=-static CC=\"\${CC} \${CFLAGS} -static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include\" LDFLAGS=\"-L${cwsw}/netbsdcurses/current/lib -static\" CFLAGS=\"\${CFLAGS}\" CC=\"\${CC} \${CFLAGS} -static\"
  cwmkdir \"${ridir}/share/${rname}/helpers\"
  rm -f ${ridir}/share/${rname}/helpers/*
  cp -a history mksignal mkstatval tripping \"${ridir}/share/${rname}/helpers/\"
  \$(\${CC} -dumpmachine)-strip \"${ridir}/bin/${rname}\" ${ridir}/share/${rname}/helpers/*
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
