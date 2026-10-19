#
# XXX - openssl variant, per usual
# XXX - docs/man require `asciidoc`
#
rname="proxytunnel"
rver="1.13.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/proxytunnel/proxytunnel/archive/refs/tags/${rfile}"
rsha256="1b1ae36327254cac351aa5358767c177b050ab4ce4a75fa100244da7816849e9"
rreqs="bootstrapmake libressl pkgconf"

. "${cwrecipe}/common.sh"

# XXX - cwpatch_???
eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cat Makefile > Makefile.ORIG
  sed -i \"s,/usr/local,\$(cwidir_${rname}),g\" Makefile docs/Makefile
  sed -i 's, pkg-config , ${cwsw}/pkgconf/current/bin/pkgconf ,g' Makefile docs/Makefile
  sed -i '/MAKE.*docs.*install/d' Makefile
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    export PKG_CONFIG_{LIBDIR,PATH}=\"${cwsw}/libressl/current/lib/pkgconfig\"
    export LDFLAGS=\"-L${cwsw}/libressl/current/lib -static\"
    export CPPFLAGS=\"-I${cwsw}/libressl/current/include\"
    make
  )
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

# vim: set ft=bash:
