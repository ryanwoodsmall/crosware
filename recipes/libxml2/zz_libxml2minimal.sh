rname="libxml2minimal"
rver="$(cwver_libxml2)"
rdir="$(cwdir_libxml2)"
rfile="$(cwfile_libxml2)"
rdlfile="$(cwdlfile_libxml2)"
rurl="$(cwurl_libxml2)"
rsha256="$(cwsha256_libxml2)"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

for f in fetch clean extract patch ; do
  eval "function cw${f}_${rname}() { cw${f}_libxml2 ; }"
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --with-ftp \
    --with-http \
    --with-legacy \
    --without-coverage \
    --without-debug \
    --without-icu \
    --without-iso8859x \
    --without-lzma \
    --without-python \
    --without-zlib \
      C{,XX}FLAGS=\"\${CFLAGS} -Os -g0 -Wl,-s\" \
      LDFLAGS='-static -s' \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
  sed -i.ORIG '/SUBDIRS.*=.*doc/s, doc , ,g' Makefile
  popd &>/dev/null
}
"
