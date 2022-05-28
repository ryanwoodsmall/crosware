#
# XXX - man pages need pod2man/perl
#

rname="tinyproxy"
rver="1.11.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/${rname}/${rname}/releases/download/${rver}/${rfile}"
rsha256="d66388448215d0aeb90d0afdd58ed00386fb81abc23ebac9d80e194fceb40f7c"
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
