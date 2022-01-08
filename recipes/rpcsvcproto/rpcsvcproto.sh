rname="rpcsvcproto"
rver="1.4.3"
rdir="rpcsvc-proto-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/thkukuk/rpcsvc-proto/releases/download/v${rver}/${rfile}"
rsha256="69315e94430f4e79c74d43422f4a36e6259e97e67e2677b2c7d7060436bd99b1"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --disable-nls \
      LDFLAGS='-s -static' \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
