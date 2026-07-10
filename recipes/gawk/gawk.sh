rname="gawk"
rver="5.4.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/gawk/${rfile}"
rsha256="8b3b0ea83930311a3f30905d3ce898d32c6103c2fe20d6a90b40341171b174de"
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
