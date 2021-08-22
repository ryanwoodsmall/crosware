rname="inadyn"
rver="2.8.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/troglobit/${rname}/releases/download/v${rver}/${rfile}"
rsha256="1185a9fb165bfc5f5b5f66f0dd8a695c9bd78d4b20cd162273eeea77f2d2e685"
rreqs="make openssl libconfuse pkgconfig zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"${cwsw}/pkgconfig/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
      --enable-openssl \
      --without-systemd \
        CPPFLAGS=\"\$(echo -I${cwsw}/{openssl,libconfuse,zlib}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{openssl,libconfuse,zlib}/current/lib) -static\" \
        PKG_CONFIG_LIBDIR=\"\$(echo ${cwsw}/{openssl,libconfuse,zlib}/current/lib/pkgconfig | tr ' ' ':')\" \
        PKG_CONFIG_PATH=\"\$(echo ${cwsw}/{openssl,libconfuse,zlib}/current/lib/pkgconfig | tr ' ' ':')\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
