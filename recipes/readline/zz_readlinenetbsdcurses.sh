rname="readlinenetbsdcurses"
rver="$(cwver_readline)"
rdir="$(cwdir_readline)"
rfile="$(cwfile_readline)"
rdlfile="$(cwdlfile_readline)"
rurl="$(cwurl_readline)"
rsha256="$(cwsha256_readline)"
rreqs="make netbsdcurses sed patch"
rpfile="${cwrecipe}/${rname%netbsdcurses}/${rname%netbsdcurses}.patches"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

for f in fetch fetchpatches clean extract patch ; do
  eval "function cw${f}_${rname}() { cw${f}_${rname%netbsdcurses} ; }"
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=\"${cwsw}/netbsdcurses/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
      --with-curses \
        CFLAGS=\"\${CFLAGS} -fPIC\" \
        CXXFLAGS=\"\${CXXFLAGS} -fPIC\" \
        CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include\" \
        LDFLAGS=\"-L${cwsw}/netbsdcurses/current/lib -static\" \
        LIBS=\"-lcurses -lterminfo\" \
        PKG_CONFIG_{LIBDIR,PATH}=\"${cwsw}/netbsdcurses/current/lib/pkgconfig\"
  popd &>/dev/null
}
"
