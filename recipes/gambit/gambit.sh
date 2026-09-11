#
# XXX - need a "make modules" in here?
#
rname="gambit"
rver="4.9.8"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/gambit/gambit/archive/${rfile}"
rsha256="0ec19b755dbda6c540e9e60b7235d801f26f40c2f211ddfb729b756218bcc873"
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
