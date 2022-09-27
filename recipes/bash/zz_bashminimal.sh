#
# XXX - this is the minimal usable bash, mostly for scripting; using it interactively will probably be a very bad time
# XXX - 'termcap' package support worth it? (no)
# XXX - add to path at very end? or... prepend?
# XXX - include a ${CW_BASH} top-level var, just use bash, otherwise check for this packages "cwbash"???
# XXX - version number/recipe patch file/...? - requires gnu patch, so probably not since that bloats reqs
#

rname="bashminimal"
rver="$(cwver_bash)"
rdir="$(cwdir_bash)"
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
  ./configure ${cwconfigureprefix} \
    --disable-nls \
    --disable-separate-helpfiles \
    --enable-readline \
    --without-curses \
    --enable-static-link \
    --without-bash-malloc \
      CC=\"\${CC} -Os -Wl,-s\" \
      CFLAGS=\"\${CFLAGS} -Os -pipe -Wl,-s\" \
      CXXFLAGS=\"\${CXXFLAGS} -Os -pipe -Wl,-s\" \
      LDFLAGS='-static -s' \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}= \
      YACC=
  echo '#define SSH_SOURCE_BASHRC' >> config-top.h
  echo '#define NON_INTERACTIVE_LOGIN_SHELLS' >> config-top.h
  echo '#define SYS_BASHRC \"/etc/bash.bashrc\"' >> config-top.h
  echo '#define SYS_BASH_LOGOUT \"/etc/bash.bash_logout\"' >> config-top.h
  popd >/dev/null 2>&1
}
"

# XXX - why? twice? where's the race?
eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make -j${cwmakejobs} ${rlibtool} LDFLAGS='-static -s' CPPFLAGS= PKG_CONFIG_{LIBDIR,PATH}= YACC= \
  || make -j${cwmakejobs} ${rlibtool} LDFLAGS='-static -s' CPPFLAGS= PKG_CONFIG_{LIBDIR,PATH}= YACC= \
     || make ${rlibtool} LDFLAGS='-static -s' CPPFLAGS= PKG_CONFIG_{LIBDIR,PATH}= YACC=
  popd >/dev/null 2>&1
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
