#
# XXX - need a "make modules" in here?
#
rname="gambit"
rver="4.9.6"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/gambit/gambit/archive/${rfile}"
rsha256="6fc1fa06262e03c1b4215977e75bdbbd80d09b3819683ac2124c5ac94781272c"
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
