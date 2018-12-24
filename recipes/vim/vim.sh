rname="vim"
rver="8.1.0610"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/${rname}/${rname}/archive/${rfile}"
rsha256="590877075f592303ca5846ebd4db58a1cedc84f6c86ef63218c1f80b9a3891d5"
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
