#
# XXX - man pages need pod2man/perl
#

rname="tinyproxy"
rver="1.11.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/${rname}/${rname}/releases/download/${rver}/${rfile}"
rsha256="c1ec81cfc4c551d2c24e0227a5aeeaad8723bd9a39b61cd729e516b82eaa3f32"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --disable-{debug,manpage_support} \
    --enable-{xtinyproxy,filter,upstream,reverse,transparent} \
    --with-stathost=\"${rname}-stats.crosware\" \
      LDFLAGS=-static \
      CPPFLAGS=
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
