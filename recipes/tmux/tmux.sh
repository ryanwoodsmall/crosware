#
# XXX - 3.4 breaks my tmux-nodes.sh stuff in tmuxmisc, need to figure that out
# XXX - explicitly disable jemalloc
#
rname="tmux"
rver="3.5a"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/tmux/tmux/releases/download/${rver}/${rfile}"
rsha256="16216bd0877170dfcc64157085ba9013610b12b082548c7c9542cc0103198951"
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
