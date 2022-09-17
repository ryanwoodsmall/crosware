rname="bim3"
rver="3.1.0"
rdir="${rname%%3}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/klange/${rname%%3}/archive/${rfile}"
rsha256="33e0c4705d6f1fb8c9d3f34730b205a3e9c2233caa7c7442dc12499c640bad9d"
rreqs="bootstrapmake kuroko"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i \"s#^prefix=.*#prefix=\$(cwidir_${rname})#g\" Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/kuroko/current/static/bin:\${PATH}\" \
    make \
      CPPFLAGS=\"-I${cwsw}/kuroko/current/static/include\" \
      LDFLAGS=\"-L${cwsw}/kuroko/current/static/lib -static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install
  \$(\${CC} -dumpmachine)-strip --strip-all \"\$(cwidir_${rname})/bin/${rname%%3}\"
  ln -sf \"${rname%%3}\" \"\$(cwidir_${rname})/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
