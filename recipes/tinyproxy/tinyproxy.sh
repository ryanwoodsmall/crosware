#
# XXX - man pages need pod2man/perl
#
rname="tinyproxy"
rver="1.11.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/${rname}/${rname}/releases/download/${rver}/${rfile}"
rsha256="9bcf46db1a2375ff3e3d27a41982f1efec4706cce8899ff9f33323a8218f7592"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --disable-{debug,manpage_support} \
    --enable-{xtinyproxy,filter,upstream,reverse,transparent} \
    --with-stathost=\"${rname}-stats.crosware\" \
      LDFLAGS=-static \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
