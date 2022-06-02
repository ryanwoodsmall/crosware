rname="pv"
rver="1.6.6"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/icetee/${rname}/archive/refs/tags/${rfile}"
rsha256="74a78d4682b91cb7eeb6247780f882871b56fca157ce26dfeb69de14c81ad20c"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --disable-nls \
      LDFLAGS=-static \
      PKG_CONFIG_{LIBDIR,PATH}= \
      CPPFLAGS=
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
