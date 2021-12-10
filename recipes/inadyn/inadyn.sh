rname="inadyn"
rver="2.9.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/troglobit/${rname}/releases/download/v${rver}/${rfile}"
rsha256="0094d20cfcd431674b8d658e93169c7589bf8f2b351b2860818a1ca05f0218c5"
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
