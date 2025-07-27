#
# XXX - need a "make modules" in here?
#
rname="gambit"
rver="4.9.7"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/gambit/gambit/archive/${rfile}"
rsha256="0da7c9772a2186dab1fba6bf6c777afe7424f40beacadf1b117d5cc825fe2db3"
rreqs="make configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} \
    CFLAGS=-fPIC \
    CXXFLAGS=-fPIC \
    LDFLAGS= \
    CPPFLAGS= \
    PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool}
  ln -sf \"${rtdir}/current/bin/gsi\" \"${ridir}/bin/${rname}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
