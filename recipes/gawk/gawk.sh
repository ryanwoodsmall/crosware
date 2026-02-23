rname="gawk"
rver="5.4.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/gawk/${rfile}"
rsha256="df5756d50772212a8e3f26d903107ece3773c4037c6a9e0a59c2a0a8d7329f0d"
rreqs="bootstrapmake sed"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} \
    --disable-extensions \
    --disable-mpfr \
    --disable-nls \
    --disable-pma \
    --without-readline \
      LDFLAGS=-static \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
