rname="vim"
rver="8.1.1086"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/${rname}/${rname}/archive/${rfile}"
rsha256="8fc0f981b27da9017585f4ee0dc12947b4ba334fdd502b260d7b3ae17af5c3ff"
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
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ( cd src ; make auto/osdef.h )
  env PATH=\"${cwsw}/gettexttiny/current/bin:\${PATH}\" \
    make -j${cwmakejobs}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  # XXX - prepend to prefer our vim/xxd/etc.
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
