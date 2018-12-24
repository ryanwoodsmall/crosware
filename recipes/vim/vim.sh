rname="vim"
rver="8.1.0625"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/${rname}/${rname}/archive/${rfile}"
rsha256="2bbd5eee9db91e8b630843ea739eb995620e27ddb8e6624a2491342291ee8b27"
rreqs="make ncurses lua gettexttiny"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
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
function cwgenprofd_${rname}() {
  # XXX - prepend to prefer our vim/xxd/etc.
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
