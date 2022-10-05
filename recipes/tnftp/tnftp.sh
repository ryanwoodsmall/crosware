rname="tnftp"
rver="20210827"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.netbsd.org/pub/NetBSD/misc/${rname}/${rfile}"
rsha256="101901e90b656c223ec8106370dd0d783fb63d26aa6f0b2a75f40e86a9f06ea2"
rreqs="make netbsdcurses libeditnetbsdcurses configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} ${cwconfigurelibopts} \
    --disable-ssl \
    --enable-editcomplete \
    --without-socks \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      LIBS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -ledit -lcurses -lterminfo\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make -j${cwmakejobs} ${rlibtool} \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include) -I. -I..\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
