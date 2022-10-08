rname="libeditnetbsdcurses"
rver="$(cwver_libedit)"
rdir="$(cwdir_libedit)"
rfile="$(cwfile_libedit)"
rdlfile="$(cwdlfile_libedit)"
rurl="$(cwurl_libedit)"
rsha256="$(cwsha256_libedit)"
rreqs="bootstrapmake netbsdcurses"
rpfile="${cwrecipe}/${rname%netbsdcurses}/${rname%netbsdcurses}.patches"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/netbsdcurses/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
      CFLAGS=\"\${CFLAGS} -fPIC -D__STDC_ISO_10646__=201206L\" \
      CXXFLAGS=\"\${CXXFLAGS} -fPIC -D__STDC_ISO_10646__=201206L\" \
      CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include\" \
      LDFLAGS=\"-L${cwsw}/netbsdcurses/current/lib -static\" \
      LIBS=\"-lcurses -lterminfo\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"${cwsw}/netbsdcurses/current/lib/pkgconfig\"
  popd >/dev/null 2>&1
}
"
