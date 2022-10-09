rname="bashtiny"
rver="$(cwver_bash)"
rver="${rver%.*}"
rdir="$(cwdir_bash)"
rdir="${rdir%.*}"
rbdir="$(cwbdir_bash)"
rfile="$(cwfile_bash)"
rdlfile="$(cwdlfile_bash)"
rurl="$(cwurl_bash)"
rsha256="$(cwsha256_bash)"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG \"s,/etc/termcap,${cwetc}/termcap,g\" lib/termcap/termcap.c
  ./configure ${cwconfigureprefix} \
    --disable-nls \
    --disable-separate-helpfiles \
    --disable-readline \
    --without-curses \
    --enable-static-link \
    --without-bash-malloc \
      CC=\"\${CC} -g0 -Os -Wl,-s\" \
      CFLAGS=\"\${CFLAGS} -g0 -Os -pipe -Wl,-s\" \
      CXXFLAGS=\"\${CXXFLAGS} -g0 -Os -pipe -Wl,-s\" \
      LDFLAGS='-static -s' \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}= \
      YACC=
  echo '#define SSH_SOURCE_BASHRC' >> config-top.h
  echo '#define NON_INTERACTIVE_LOGIN_SHELLS' >> config-top.h
  echo '#define SYS_BASHRC \"/etc/bash.bashrc\"' >> config-top.h
  echo '#define SYS_BASH_LOGOUT \"/etc/bash.bash_logout\"' >> config-top.h
  echo '#undef DEFAULT_LOADABLE_BUILTINS_PATH' >> config-top.h
  echo '#define DEFAULT_LOADABLE_BUILTINS_PATH \"${rtdir}/current/lib/bash:.\"' >> config-top.h
  popd >/dev/null 2>&1
}
"

# XXX - hmm
eval "
function cwmake_${rname}() {
  cwmake_bashminimal
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  rm -f \"\$(cwidir_${rname})/bin/bash\"
  rm -f \"\$(cwidir_${rname})/bin/${rname}\"
  make install ${rlibtool} LDFLAGS='-static -s' CPPFLAGS= PKG_CONFIG_{LIBDIR,PATH}= YACC=
  mv -f \"\$(cwidir_${rname})/bin/bash\" \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/bash\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/cwbash\"
  popd >/dev/null 2>&1
}
"
