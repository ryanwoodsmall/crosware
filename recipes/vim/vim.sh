#
# XXX - disable mouse? ugh
#

rname="vim"
rver="8.2.4911"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/${rname}/${rname}/archive/${rfile}"
rsha256="200b9742f1a042616cebf532c243939af2f76facef90d846aa60d21a8a3805d7"
rreqs="make ncurses lua gettexttiny attr acl libsodium"

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
  ln -sf \"${rname}\" \"${ridir}/bin/vi\"
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
