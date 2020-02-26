rname="bim"
rver="2.6.1"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/klange/${rname}/archive/${rfile}"
rsha256="734f9b3152f00bb236451dea5180d390992557bf622baa718f9a41989b24e93a"
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
