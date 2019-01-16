rname="vim"
rver="8.1.0755"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/${rname}/${rname}/archive/${rfile}"
rsha256="2b0a55874b2e05262e59d7be5aefb629b07097f4aa35410657b9989ca74e0a73"
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
