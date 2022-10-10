rname="vimminimal"
rver="$(cwver_vim)"
rdir="$(cwdir_vim)"
rfile="$(cwfile_vim)"
rdlfile="$(cwdlfile_vim)"
rurl="$(cwurl_vim)"
rsha256=""
rprof="${cwetcprofd}/zz_${rname}.sh"
rreqs="bootstrapmake bashtermcap"

. "${cwrecipe}/common.sh"

for f in fetch clean make ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_${rname%minimal}
  }
  "
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --with-tlib=termcap \
    --without-local-dir \
    --with-features=huge \
    --without-x \
    --enable-gui=no \
    --enable-luainterp=no \
    --disable-luainterp \
    --disable-nls \
      CFLAGS=\"\${CFLAGS} -Os -g0 -Wl,-s\" \
      CXXFLAGS=\"\${CXXFLAGS} -Os -g0 -Wl,-s\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
      LIBS='-ltermcap' \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  local sv
  sv=\"${rver%.*}\"
  sv=\"\${sv//./}\"
  make install ${rlibtool}
  ln -sf \"${rtdir}/current/share/vim/vim\${sv}/macros/less.sh\" \"\$(cwidir_${rname})/bin/vimless\"
  ln -sf \"${rname%}\" \"\$(cwidir_${rname})/bin/vi\"
  echo ln -sf \"${rname%minimal}\" \"\$(cwidir_${rname})/bin/${rname}\"
  echo '#!/usr/bin/env bash' > \"\$(cwidir_${rname})/bin/${rname}\"
  echo 'env TERM=xterm-color \"${rtdir}/current/bin/vim\" \"\${@}\"' >> \"\$(cwidir_${rname})/bin/${rname}\"
  chmod 755 \"\$(cwidir_${rname})/bin/${rname}\"
  unset sv
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir%minimal}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir//minimal/netbsdcurses}/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
