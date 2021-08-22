rname="inadynlibressl"
rver="$(cwver_inadyn)"
rdir="$(cwdir_inadyn)"
rfile="$(cwfile_inadyn)"
rurl="$(cwurl_inadyn)"
rsha256=""
rreqs="make libressl libconfuse pkgconfig zlib"

. "${cwrecipe}/common.sh"

for f in clean fetch extract make ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_${rname%%libressl}
  }
  "
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"${cwsw}/pkgconfig/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
      --enable-openssl \
      --without-systemd \
        CPPFLAGS=\"\$(echo -I${cwsw}/{libressl,libconfuse,zlib}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{libressl,libconfuse,zlib}/current/lib) -static\" \
        PKG_CONFIG_LIBDIR=\"\$(echo ${cwsw}/{libressl,libconfuse,zlib}/current/lib/pkgconfig | tr ' ' ':')\" \
        PKG_CONFIG_PATH=\"\$(echo ${cwsw}/{libressl,libconfuse,zlib}/current/lib/pkgconfig | tr ' ' ':')\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  ln -sf \"${rname%%libressl}\" \"${ridir}/sbin/${rname%%libressl}-${rname##inadyn}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
