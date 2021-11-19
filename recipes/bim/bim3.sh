rname="bim3"
rver="3.0.0"
rdir="${rname%%3}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/klange/${rname%%3}/archive/${rfile}"
rsha256="6b7044b3579cc7c39528e7aefce200ac893245dbdb9c017ae41f85e1647ddaa8"
rreqs="bootstrapmake kuroko"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i 's#^prefix=.*#prefix=${ridir}#g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"${cwsw}/kuroko/current/static/bin:\${PATH}\" \
    make \
      CPPFLAGS=\"-I${cwsw}/kuroko/current/static/include\" \
      LDFLAGS=\"-L${cwsw}/kuroko/current/static/lib -static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install
  \$(\${CC} -dumpmachine)-strip --strip-all \"${ridir}/bin/${rname%%3}\"
  ln -sf \"${rname%%3}\" \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
