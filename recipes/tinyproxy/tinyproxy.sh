#
# XXX - man pages need pod2man/perl
#
rname="tinyproxy"
rver="1.11.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/${rname}/${rname}/releases/download/${rver}/${rfile}"
rsha256="2c8fe5496f2c642bfd189020504ab98d74b9edbafcdb94d9f108e157b5bdf96d"
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
