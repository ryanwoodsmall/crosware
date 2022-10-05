rname="slangnetbsdcurses"
rver="$(cwver_slang)"
rdir="$(cwdir_slang)"
rfile="$(cwfile_slang)"
rdlfile="$(cwdlfile_slang)"
rurl="$(cwurl_slang)"
rsha256="$(cwsha256_slang)"
rreqs="make netbsdcurses zlib configgit"
rpfile="${cwrecipe}/${rname%netbsdcurses}/${rname%netbsdcurses}.patches"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_slang)\" >/dev/null 2>&1
  sed -i.ORIG \"s/TERMCAP=-ltermcap/TERMCAP='-lcurses -lterminfo'/g\" configure
  env PATH=\"${cwsw}/netbsdcurses/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
      CFLAGS=\"\${CFLAGS} -fPIC\" \
      CXXFLAGS=\"\${CXXFLAGS} -fPIC\" \
      CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include\" \
      LDFLAGS=\"-L${cwsw}/netbsdcurses/current/lib -static\" \
      LIBS=\"-lcurses -lterminfo\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"${cwsw}/netbsdcurses/current/lib/pkgconfig\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_slang)\" >/dev/null 2>&1
  make -j${cwmakejobs} static ${rlibtool}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_slang)\" >/dev/null 2>&1
  make install-static ${rlibtool}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
