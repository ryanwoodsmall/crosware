rname="vimminimal"
rver="$(cwver_vim)"
rdir="$(cwdir_vim)"
rfile="$(cwfile_vim)"
rdlfile="$(cwdlfile_vim)"
rurl="$(cwurl_vim)"
rsha256=""
rprof="${cwetcprofd}/zz_${rname}.sh"
rreqs="bootstrapmake bashtermcap lua libsodium"

. "${cwrecipe}/common.sh"

for f in fetch clean extract patch make ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_${rname%minimal}
  }
  "
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} \
    --with-tlib=termcap \
    --without-local-dir \
    --with-features=huge \
    --without-x \
    --enable-gui=no \
    --disable-nls \
    --with-lua-prefix=${cwsw}/lua/current \
    --enable-luainterp=yes \
    --enable-libsodium \
      CFLAGS=\"\${CFLAGS} -Os -g0 -Wl,-s\" \
      CXXFLAGS=\"\${CXXFLAGS} -Os -g0 -Wl,-s\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      LIBS='-ltermcap'
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  local sv
  sv=\"${rver%.*}\"
  sv=\"\${sv//./}\"
  make install ${rlibtool}
  ln -sf \"${rtdir}/current/share/vim/vim\${sv}/macros/less.sh\" \"\$(cwidir_${rname})/bin/vimless\"
  ln -sf \"${rname%%minimal}\" \"\$(cwidir_${rname})/bin/vi\"
  cwmkdir \$(cwidir_${rname})/wrapper/bin
  for p in \$(find \$(cwidir_${rname})/bin/ ! -type d -exec basename '{}' \\;) ; do
    rm -f \"\$(cwidir_${rname})/wrapper/bin/\${p}\" || true
    printf '#!/usr/bin/env bash\\n'     | tee    \"\$(cwidir_${rname})/wrapper/bin/\${p}\" &>/dev/null
    printf 'export TERM=xterm-color\\n' | tee -a \"\$(cwidir_${rname})/wrapper/bin/\${p}\" &>/dev/null
    printf 'exec \"%s\" \"%s\"\\n' \"${rtdir}/current/bin/\${p}\" '\${@}' \
                                        | tee -a \"\$(cwidir_${rname})/wrapper/bin/\${p}\" &>/dev/null
  done
  rm -f \"\$(cwidir_${rname})/wrapper/bin/${rname}\" || true
  cat \"\$(cwidir_${rname})/wrapper/bin/vim\" > \"\$(cwidir_${rname})/wrapper/bin/${rname}\"
  chmod 755 \$(cwidir_${rname})/wrapper/bin/*
  unset p sv
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir%minimal}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir//minimal/netbsdcurses}/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/wrapper/bin\"' >> \"${rprof}\"
}
"

# vim: set ft=bash:
