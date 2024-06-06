rname="findutils"
rver="4.10.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/findutils/${rfile}"
rsha256="1387e0b67ff247d2abde998f90dfbf70c1491391a59ddfecb8ae698789f0a4f5"
rreqs="make busybox sed configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} --disable-nls LDFLAGS=-static CPPFLAGS= PKG_CONFIG_{LIBDIR,PATH}=
  echo '#include <sys/sysmacros.h>' >> config.h
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
