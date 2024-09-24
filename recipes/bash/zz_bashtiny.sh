#
# XXX - this is the minimal usable bash, mostly for scripting; using it interactively will probably be a very bad time
#
rname="bashtiny"
rver="$(cwver_bash)"
rdir="$(cwdir_bash)"
rbdir="$(cwbdir_bash)"
rfile="$(cwfile_bash)"
rdlfile="$(cwdlfile_bash)"
rurl="$(cwurl_bash)"
rsha256="$(cwsha256_bash)"
rreqs="bootstrapmake patch"
rpfile="${cwrecipe}/bash/bash.patches"

. "${cwrecipe}/common.sh"

eval "function cwfetchpatches_${rname}() { cwfetchpatches_bash ; }"
eval "function cwpatch_${rname}() { cwpatch_bash ; }"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
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
  popd &>/dev/null
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
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  rm -f \"\$(cwidir_${rname})/bin/bash\"
  rm -f \"\$(cwidir_${rname})/bin/${rname}\"
  make install ${rlibtool} LDFLAGS='-static -s' CPPFLAGS= PKG_CONFIG_{LIBDIR,PATH}= YACC=
  mv -f \"\$(cwidir_${rname})/bin/bash\" \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/sh\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/bash\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/cwbash\"
  popd &>/dev/null
}
"
