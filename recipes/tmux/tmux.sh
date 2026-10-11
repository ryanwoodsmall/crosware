#
# XXX - 3.4 breaks my tmux-nodes.sh stuff in tmuxmisc, need to figure that out
# XXX - explicitly disable jemalloc
#
rname="tmux"
rver="3.8"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/tmux/tmux/releases/download/${rver}/${rfile}"
rsha256="e79c699c7e949dccd0a4a125e17b8d1261e311b16979dbc8eb34542f3966d82e"
rreqs="make libevent netbsdcurses pkgconfig byacc"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=\"${cwsw}/byacc/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      CPPFLAGS=\"-I${cwsw}/libevent/current/include -I${cwsw}/netbsdcurses/current/include\" \
      LDFLAGS=\"-L${cwsw}/libevent/current/lib -L${cwsw}/netbsdcurses/current/lib -static\" \
      LIBS=\"-lcurses -lterminfo\" \
      YACC=byacc \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
