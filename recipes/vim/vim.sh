rname="vim"
rver="8.1.1982"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/${rname}/${rname}/archive/${rfile}"
rsha256="3ea3dd94a0afcda4db4116f4c5e58f887e21d17874188c4d8d3bd0e6f19c4f25"
rreqs="make ncurses lua gettexttiny"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=${cwsw}/gettexttiny/current/bin:\${PATH} \
    ./configure ${cwconfigureprefix} \
      --with-tlib=ncurses \
      --without-local-dir \
      --with-features=huge \
      --without-x \
      --enable-gui=no \
      --with-lua-prefix=${cwsw}/lua/current \
      --enable-luainterp=yes
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ( cd src ; make auto/osdef.h )
  env PATH=\"${cwsw}/gettexttiny/current/bin:\${PATH}\" \
    make -j${cwmakejobs}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  local sv
  sv=\"${rver%.*}\"
  sv=\"\${sv//./}\"
  make install ${rlibtool}
  ln -sf \"${rtdir}/current/share/vim/vim\${sv}/macros/less.sh\" \"${ridir}/bin/vimless\"
  unset sv
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  # XXX - prepend to prefer our vim/xxd/etc.
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
