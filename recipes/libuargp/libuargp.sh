rname="libuargp"
rver="1f92296a97ef8fcfeb5e2440f5a62081fe654f75"
rdir="${rname}-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/xhebox/libuargp/archive/1f92296a97ef8fcfeb5e2440f5a62081fe654f75.zip"
rsha256=""
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetch \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cat Makefile > Makefile.ORIG
  sed -i \"/^prefix=/s,.*,prefix=\$(cwidir_${rname}),g\" Makefile
  sed -i \"/^ALL_LIBS=/s,=.*,=libargp.a,g\" Makefile
  popd >/dev/null 2>&1
}
"
