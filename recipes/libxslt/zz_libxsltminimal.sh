rname="libxsltminimal"
rver="$(cwver_libxslt)"
rdir="$(cwdir_libxslt)"
rfile="$(cwfile_libxslt)"
rdlfile="$(cwdlfile_libxslt)"
rurl="$(cwurl_libxslt)"
rsha256="$(cwsha256_libxslt)"
rreqs="bootstrapmake libxml2minimal"

. "${cwrecipe}/common.sh"

for f in fetch clean extract patch ; do
  eval "function cw${f}_${rname}() { cw${f}_libxslt ; }"
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=\"${cwsw}/libxml2minimal/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
      --with-libxml-prefix=\"${cwsw}/libxml2minimal/current\" \
      --without-crypto \
      --without-debug \
      --without-debugger \
      --without-plugins \
      --without-profiler \
      --without-python \
        C{,XX}FLAGS=\"\${CFLAGS} -Os -g0 -Wl,-s\" \
        LDFLAGS=\"-L${cwsw}/libxml2minimal/current/lib -static -s\" \
        CPPFLAGS=\"-I${cwsw}/libxml2minimal/current/include\" \
        PKG_CONFIG_{LIBDIR,PATH}=\"${cwsw}/libxml2minimal/current/lib/pkgconfig\"
  sed -i.ORIG '/SUBDIRS.*=.*doc/s, doc , ,g' Makefile
  popd &>/dev/null
}
"
