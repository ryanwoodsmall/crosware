rname="bim"
rver="2.6.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/klange/${rname}/archive/${rfile}"
rsha256="11dc1da86437d365886dffe4d41e00e3309358a6bdcd4e1dd727dc4231ebcc4a"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG 's/-flto//g' Makefile
  sed -i 's#^prefix=.*#prefix=${ridir}#g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  \$(\${CC} -dumpmachine)-strip --strip-all \"${ridir}/bin/${rname}\"
  cwmkdir \"${ridir}/themes\"
  install -m 0644 themes/* \"${ridir}/themes/\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
