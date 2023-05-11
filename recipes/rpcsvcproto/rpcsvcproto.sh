rname="rpcsvcproto"
rver="1.4.4"
rdir="rpcsvc-proto-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/thkukuk/rpcsvc-proto/releases/download/v${rver}/${rfile}"
rsha256="81c3aa27edb5d8a18ef027081ebb984234d5b5860c65bd99d4ac8f03145a558b"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
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
