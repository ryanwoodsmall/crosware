rname="vimnetbsdcurses"
rver="$(cwver_vim)"
rdir="$(cwdir_vim)"
rfile="$(cwfile_vim)"
rdlfile="$(cwdlfile_vim)"
rurl="$(cwurl_vim)"
rsha256=""
rprof="${cwetcprofd}/zz_${rname}.sh"
rreqs="make lua netbsdcurses gettexttiny libsodium"

. "${cwrecipe}/common.sh"

for f in fetch clean extract patch make ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_${rname%netbsdcurses}
  }
  "
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=${cwsw}/gettexttiny/current/bin:\${PATH} \
    ./configure ${cwconfigureprefix} \
      --with-tlib=curses \
      --without-local-dir \
      --with-features=huge \
      --without-x \
      --enable-gui=no \
      --with-lua-prefix=${cwsw}/lua/current \
      --enable-luainterp=yes \
      --enable-libsodium \
        CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
        PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
        LIBS='-lcurses -lterminfo'
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
  ln -sf \"${rname%netbsdcurses}\" \"\$(cwidir_${rname})/bin/vi\"
  ln -sf \"${rname%netbsdcurses}\" \"\$(cwidir_${rname})/bin/${rname}\"
  unset sv
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'prepend_path \"${cwsw}/${rname%netbsdcurses}/current/bin\"' >> \"${rprof}\"
}
"
