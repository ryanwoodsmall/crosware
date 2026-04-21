#
# XXX - this is the bare lib only!
# XXX - apps need(?)...
# XXX - libxml2
# XXX - libev
# XXX - zlib
# XXX - ... and NEED separate openssl, libressl and wolfssl variants for apps, examples
#
rname="nghttp2"
rver="1.69.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/nghttp2/nghttp2/releases/download/v${rver}/${rfile}"
rsha256="c866b7477cbb7512ab6863a685027adbb1bb8da8fc3bab7429ed43d3281d5aa9"
rreqs="bootstrapmake busybox bashtiny slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=\"\$(echo ${cwsw}/{bashtiny,busybox,bootstrapmake,slibtool,ccache{,4},statictoolchain}/current/bin | tr ' ' ':')\" \
    \"${cwsw}/bashtiny/current/bin/bash\" \
      ./configure \
        --disable-app \
        --disable-examples \
        --enable-lib-only \
          ${cwconfigureprefix} \
          ${cwconfigurelibopts} \
          ${rconfigureopts} \
          ${rcommonopts} \
            LDFLAGS=-static \
            CPPFLAGS= \
            PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make -j${cwmakejobs} ${rlibtool} \
    LDFLAGS=-static \
    CPPFLAGS= \
    PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool} \
    LDFLAGS=-static \
    CPPFLAGS= \
    PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
